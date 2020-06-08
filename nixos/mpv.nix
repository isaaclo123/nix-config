{ config, pkgs, ... }:

let
  username = (import ./settings.nix).username;
  icon = (import ./settings.nix).icon;
  mpv-thumbnail-pkg = (import ./mpv-thumbnail.nix);
in

let
  mpv-socket = "/tmp/mpv-scratchpad-socket";
  mpv-thumbs-cache = "/tmp/mpv_thumbs_cache";
  mpv-gallery-thumb-dir = "/tmp/mpv_gallery_cache";
  fullscreen-lock = "/tmp/mpv-scratchpad-fullscreen.lock";
in

{
  environment.systemPackages =
    let
      mpv-scratchpad = (pkgs.writeShellScriptBin "mpv-scratchpad" ''
        SOCKET=${mpv-socket}
        FULLSCREEN=${fullscreen-lock}
        rm -f $FULLSCREEN

        mkdir -p ${mpv-gallery-thumb-dir}

        mpv --input-ipc-server=$SOCKET --x11-name=mpvscratchpad --title=mpvscratchpad --geometry=384x216-32-0 --no-terminal --force-window --keep-open=yes --idle=yes
        '');

      mpv-scratchpad-toggle = (pkgs.writeShellScriptBin "mpv-scratchpad-toggle" ''
        VISIBLE_IDS=$(xdotool search --onlyvisible --classname 'mpvscratchpad')
        ALL_IDS=$(xdotool search --classname 'mpvscratchpad')
        ID=$(xdotool search --classname 'mpvscratchpad' | head -n1)
        FULLSCREEN=${fullscreen-lock}

        # if hidden, don't do anything
        [ -z $ALL_IDS ] && exit 0

        # sticky desktop
        bspc node $ID --flag sticky=on

        # toggle hide
        bspc node $ID --flag hidden

        ## else toggle fullscreen
        if [ -e "$FULLSCREEN" ]; then
          # is marked fullscreen, so should be fullscreen
          bspc node $ID --state fullscreen
          bspc node $ID --flag sticky=off
          bspc node --focus $ID
        else
          # is not marked fullscreen, so should be not marked fullscreen
          bspc node $ID --state floating
          bspc node $ID --flag sticky=on
          [ -z $VISIBLE_IDS ] && bspc node --focus $ID
          [ -z $VISIBLE_IDS ] && bspc node --focus last
        fi
        exit 0
      '');

      mpv-scratchpad-ctl = (pkgs.writeShellScriptBin "mpv-scratchpad-ctl" ''
        socket=${mpv-socket}

        command() {
            # JSON preamble.
            local tosend='{ "command": ['
            # adding in the parameters.
            for arg in "$@"; do
                tosend="$tosend \"$arg\","
            done
            # closing it up.
            tosend=''${tosend%?}' ] }'
            # send it along and ignore output.
            # to print output just remove the redirection to /dev/null
            # echo $tosend | socat - $socket &> /dev/null
            echo $tosend | socat - $socket
        }

        # exit mpv
        [ "$1" = "stop" ] && command 'stop'
        # toggle play-pause
        [ "$1" = "play-pause" ] && command 'cycle' 'pause'
        # start playing
        [ "$1" = "pause" ] && command 'set' 'pause' 'yes'
        # stop playing
        [ "$1" = "play" ] && command 'set' 'pause' 'no'
        # play next item in playlist
        [ "$1" = "next" ] && command 'playlist_next'
        # play previous item in playlist
        [ "$1" = "previous" ] && command 'playlist_prev'
        # seek forward
        [ "$1" = "forward" ] && command 'seek' "$2" 'relative'
        # seek backward
        [ "$1" = "backward" ] && command 'seek' "-$2" 'relative'
        # restart video
        [ "$1" = "restart" ] && (command 'seek' "0" 'absolute'; command 'set' 'pause' 'no')
        # end video
        [ "$1" = "end" ] && (command 'seek' "100" 'absolute-percent+exact'; command 'set' 'pause' 'no')
        # toggle video status
        [ "$1" = "video-novideo" ] && command 'cycle' 'video'
        # video status yes
        [ "$1" = "video" ] && command 'set' 'video' 'no' && command 'cycle' 'video'
        # video status no
        [ "$1" = "novideo" ] && command 'set' 'video' 'no'
        # add item(s) to playlist
        [ "$1" = "add" ] && shift &&
          for video in "$@"; do
              command 'loadfile' "$video" 'append-play';
          done;
        # replace item(s) in playlist
        [ "$1" = "replace" ] && shift && command 'loadfile' "$1" 'replace';
      '');

      mpv-scratchpad-open = (pkgs.writeShellScriptBin "mpv-scratchpad-open" ''
        mpv-scratchpad-ctl add "$@"
        for i in $(seq 1 1 50)
        do
          mpv-scratchpad-ctl next
        done
        mpv-scratchpad-ctl play
        exit 0
      '');

      mpv-scratchpad-fullscreen-toggle = (pkgs.writeShellScriptBin "mpv-scratchpad-fullscreen-toggle" ''
        VISIBLE_IDS=$(xdotool search --onlyvisible --classname 'mpvscratchpad')
        ALL_IDS=$(xdotool search --classname 'mpvscratchpad')
        ID=$(xdotool search --classname 'mpvscratchpad' | head -n1)
        FULLSCREEN=${fullscreen-lock}

        # if hidden, don't do anything
        [ -z $ALL_IDS ] && exit 0

        # move mpv to front
        bspc node $ID --to-desktop newest

        bspc node $ID --flag hidden=off

        if [ -e "$FULLSCREEN" ]; then
          # is marked fullscreen, so should unmark (after unfullscreen)
          bspc node $ID --state floating
          bspc node $ID --flag sticky=on
          bspc node --focus $ID
          bspc node --focus last
          rm -f $FULLSCREEN
        else
          # is not marked fullscreen, so should become fullscreen
          # bspc node $ID --to-desktop newest
          bspc node $ID --state fullscreen
          bspc node $ID --flag sticky=off
          bspc node --focus $ID
          touch $FULLSCREEN
        fi
        exit 0
      '');

      mpv-scratchpad-hide = (pkgs.writeShellScriptBin "mpv-scratchpad-hide" ''
        ID=$(xdotool search --classname 'mpvscratchpad' | head -n1)

        mpv-scratchpad-ctl pause
        bspc node $ID --flag sticky=on
        bspc node $ID --flag hidden=on
        exit 0
      '');

      mpv-window-open = (pkgs.writeShellScriptBin "mpv-window-open" ''
        # open item in mpv, try different methods

        NOTIFY_MAX_LEN=40
        url="$1"

        if [ "''${#url}" -gt "$(($NOTIFY_MAX_LEN - 2))" ]; then
            url="$(echo $1 | cut -c1-$(($NOTIFY_MAX_LEN - 1)))"
            url+="…"
        fi

        ${pkgs.libnotify}/bin/notify-send -i "${icon.path}/categories/applications-multimedia.svg" "MPV opening" "$url"

        # (mpv --force-window "gallery-dl://$@";
        #   bspc node --focus last) ||
        (mpv --force-window "gallery-dl://$@") ||
        (xdg-open "$@" &&
            ${pkgs.libnotify}/bin/notify-send -i "${icon.path}/categories/applications-internet.svg" "Browser opening" "$url") ||
        ${pkgs.libnotify}/bin/notify-send -i "${icon.path}/status/dialog-warning.svg" "Error opening" "$url"
      '');

      # this is a plugin
      mpv-image-viewer = (pkgs.fetchFromGitHub {
        owner = "occivink";
        repo = "mpv-image-viewer";
        rev = "553b61cb6fd6ded1ce396d0e0e4d70a89b681af9";
        sha256 = "0mzlbf6c7i0yixbfxqvdma5vjx70f7pvcfw74akhfpzjzw4fms8v";
      });

    in

      with pkgs; [
        (mpv-with-scripts.override {
          scripts = [
            # mpv-image-viewer
            "${mpv-image-viewer}/scripts/detect-image.lua"
            # "${mpv-image-viewer}/scripts/freeze-window.lua"
            "${mpv-image-viewer}/scripts/image-positioning.lua"
            # "${mpv-image-viewer}/scripts/minimap.lua"
            "${mpv-image-viewer}/scripts/ruler.lua"
            # "${mpv-image-viewer}/scripts/status-line.lua"

            # autosave
            # (fetchurl {
            #   url = "https://gist.githubusercontent.com/Hakkin/5489e511bd6c8068a0fc09304c9c5a82/raw/7a19f7cdb6dd0b1c6878b41e13b244e2503c15fc/autosave.lua";
            #   sha256 = "0jxykk3jis2cplysc0gliv0y961d0in4j5dpd2fabv96pfk6chdd";
            # })

            # autospeed
            (fetchurl {
              url = "https://raw.githubusercontent.com/kevinlekiller/mpv_scripts/master/autospeed/autospeed.lua";
              sha256 = "18m0lzf0gs3g0mfgwfgih6mz98v5zcciykjl7jmg9rllwsx8syjl";
            })

            # autoloop
            (fetchurl {
              url = "https://raw.githubusercontent.com/zc62/mpv-scripts/master/autoloop.lua";
              sha256 = "1g60h3c85ladx3ksixqnmg2cmpr68li38sgx167jylmgiavfaa6v";
            })

            # playlistnoplayback
            (fetchurl {
              url = "https://raw.githubusercontent.com/422658476/MPV-EASY-Player/master/portable-data/scripts/playlistnoplayback.lua";
              sha256 = "035zsm4z349m920b625zly7zaz361972is55mg02xvgpv0awclfl";
            })

            # reload
            (fetchurl {
              url = "https://raw.githubusercontent.com/4e6/mpv-reload/2b8a719fe166d6d42b5f1dd64761f97997b54a86/reload.lua";
              sha256 = "0dyx22rr1883m2lhnaig9jdp7lpjydha0ad7lj9pfwlgdr2zg4b9";
            })

            # youtube-quality
            (fetchurl {
              url = "https://raw.githubusercontent.com/jgreco/mpv-youtube-quality/1f8c31457459ffc28cd1c3f3c2235a53efad7148/youtube-quality.lua";
              sha256 = "0fi1b4r5znp2k2z590jrrbn6wirx7nggjcl1frkcwsv7gmhjl11l";
            })

            # gallery-dl_hook
            (fetchurl {
              url = "https://gist.githubusercontent.com/isaaclo123/47993f6de088bb55de27fd126f722f2a/raw/1cac024adbffb0d6334bfd3666dea1d56bb4a525/gallery-dl_hook.lua";
              sha256 = "0rc81bclfydpyil7xjpi560fmsajfc6ixmlsmchmhbb4ajxxavrs";
            })

            # peerflix-hook
            (fetchurl {
              url = "https://gist.githubusercontent.com/ekisu/bba287693830055a6bad90081c1ad4e2/raw/65a97c59b9dcfc9de94864160124fbe5eb5f3aa3/peerflix-hook.lua";
              sha256 = "08h6wzrhrp1i1pbzzrim8rwa1bkvjxdvs7rqqsnj6s4b77rg1x48";
            })

            # show_filename (shift enter)
            (fetchurl {
              url = "https://raw.githubusercontent.com/yuukidach/mpv-scripts/cbcd5b799e37b479aa55cbb8d3bb851e28f39630/show_filename.lua";
              sha256 = "1h976qymbal199f5z7sz1hban2g2mr4jb1v8zg96g5c537fix8zy";
            })

            # change-OSD-media-title
            # (fetchurl {
            #   url = "https://raw.githubusercontent.com/nmoorthy524/mpv-Change-OSD-Media-Title/62a916ea95da680bad9219313fe7fc102fd85d94/change-OSD-media-title.lua";
            #   sha256 = "11iyxkpq9nkdmr7zkscnfw5v391dzvcbjdc908snr1d77dr79n9b";
            # })
          ];
        })

        (mpv-scratchpad)
        (mpv-scratchpad-toggle)
        (mpv-scratchpad-fullscreen-toggle)
        (mpv-scratchpad-hide)
        (mpv-scratchpad-open)
        (mpv-scratchpad-ctl)

        (mpv-window-open)
        unstable.gallery-dl
        mpvc
        # ffmpeg

        nodePackages.peerflix
      ];

  systemd.user = {
    timers.mpv-thumbnail-delete = {
      wantedBy = [ "timers.target" ];
      partOf = [ "mpv-thumbnail-delete.service" ];
      timerConfig = {
        OnCalendar = "daily";
      };
    };

    services.mpv-thumbnail-delete = {
      description = "Service to delete mpv thumbnails";

      serviceConfig.Type = "oneshot";

      # delete anything older than 1 day
      script = ''
        [ -d "${mpv-thumbs-cache}" ] && \
          find ${mpv-thumbs-cache} -mtime +1 -exec rm {} \;

        [ -d "${mpv-gallery-thumb-dir}" ] && \
          find ${mpv-gallery-thumb-dir} -mtime +1 -exec rm {} \;

        exit 0
      '';

      path = with pkgs; [
        config.system.path
      ];
    };
  };

  home-manager.users."${username}" = {
    xdg.configFile =
      # mpv-gallery-view
      let
        mpv-gallery-view = (pkgs.fetchFromGitHub {
          owner = "occivink";
          repo = "mpv-gallery-view";
          rev = "da97cc6142a7cd566414f007df8fb30a46115568";
          sha256 = "1fwlz37k93n046dx56d0iaka8bzbkap76xkw4anh2hlgnbx7rq2j";
        });
      in

      {
        # mpv-gallery-view
        "mpv/scripts/lib".source = "${mpv-gallery-view}/scripts/lib";
        "mpv/scripts/gallery-thumbgen.lua".source = "${mpv-gallery-view}/scripts/gallery-thumbgen.lua";
        "mpv/scripts/playlist-view.lua".source = "${mpv-gallery-view}/scripts/playlist-view.lua";

        "mpv/scripts/mpv_thumbnail_client.lua".source = "${mpv-thumbnail-pkg}/scripts/mpv_thumbnail_script_client_osc.lua";
        "mpv/scripts/mpv_thumbnail_server.lua".source = "${mpv-thumbnail-pkg}/scripts/mpv_thumbnail_script_server.lua";
        "mpv/scripts/mpv_thumbnail_server-1.lua".source = "${mpv-thumbnail-pkg}/scripts/mpv_thumbnail_script_server.lua";
        "mpv/scripts/mpv_thumbnail_server-2.lua".source = "${mpv-thumbnail-pkg}/scripts/mpv_thumbnail_script_server.lua";

        "mpv/script-opts/mpv_thumbnail_script.conf".text = ''
          cache_directory=${mpv-thumbs-cache}
          autogenerate=yes
          autogenerate_max_duration=3600
          prefer_mpv=yes
          mpv_no_sub=no
          disable_keybinds=no
          thumbnail_width=200
          thumbnail_height=200
          thumbnail_count=120
          min_delta=5
          max_delta=90
          thumbnail_network=yes
          remote_thumbnail_count=50
          remote_min_delta=15
          remote_max_delta=120
          remote_direct_stream=yes
        '';

        "mpv/script-opts/gallery_worker.conf".text = ''
          ytdl_exclude=
        '';

        "mpv/script-opts/playlist_view.conf".text = ''
          thumbs_dir=${mpv-gallery-thumb-dir}

          generate_thumbnails_with_mpv=yes

          gallery_position={ (ww - gw) / 2, (wh - gh) / 2 }
          gallery_size={ 9 * ww / 10, 9 * wh / 10 }
          min_spacing={ 15, 15 }
          thumbnail_size=(ww * wh <= 1366 * 768) and {192, 108} or {288, 162}

          max_thumbnails=64

          take_thumbnail_at=20%

          load_file_on_toggle_off=no
          close_on_load_file=yes
          pause_on_start=yes
          resume_on_stop=only-if-did-pause
          start_on_mpv_startup=no
          start_on_file_end=no
          follow_playlist_position=yes
          remember_time_position=yes

          show_text=yes
          show_title=yes
          strip_directory=yes
          strip_extension=yes
          # text_size=20

          background_color=333333
          background_opacity=33
          normal_border_color=BBBBBB
          normal_border_size=1
          selected_border_color=DDDDDD
          selected_border_size=6
          flagged_border_color=5B9769
          flagged_border_size=4
          selected_flagged_border_color=BAFFCA
          placeholder_color=222222

          command_on_open=
          command_on_close=

          mouse_support=yes
          UP=UP
          DOWN=DOWN
          LEFT=LEFT
          RIGHT=RIGHT
          PAGE_UP=PGUP
          PAGE_DOWN=PGDWN
          FIRST=HOME
          LAST=END
          RANDOM=r
          ACCEPT=ENTER
          CANCEL=ESC
          # this only removes entries from the playlist, not the underlying file
          REMOVE=DEL
          FLAG=SPACE
        '';

        "mpv/input.conf".text = ''
          # mouse-centric bindings
          # MBTN_RIGHT script-binding drag-to-pan
          # MBTN_LEFT  script-binding pan-follows-cursor
          # WHEEL_UP   script-message cursor-centric-zoom 0.1
          # WHEEL_DOWN script-message cursor-centric-zoom -0.1

          # panning with the keyboard:
          # pan-image takes the following arguments
          # pan-image AXIS AMOUNT ZOOM_INVARIANT IMAGE_CONSTRAINED

          ctrl+j repeatable script-message pan-image y -0.1 yes yes
          ctrl+k repeatable script-message pan-image y +0.1 yes yes
          ctrl+l repeatable script-message pan-image x -0.1 yes yes
          ctrl+h repeatable script-message pan-image x +0.1 yes yes

          # now with more precision
          alt+j   repeatable script-message pan-image y -0.01 yes yes
          alt+k     repeatable script-message pan-image y +0.01 yes yes
          alt+l  repeatable script-message pan-image x -0.01 yes yes
          alt+h   repeatable script-message pan-image x +0.01 yes yes

          # replace at will with h,j,k,l if you prefer vim-style bindings

          # on a trackpad you may want to use these
          WHEEL_UP    repeatable script-message pan-image y -0.02 yes yes
          WHEEL_DOWN  repeatable script-message pan-image y +0.02 yes yes
          WHEEL_LEFT  repeatable script-message pan-image x -0.02 yes yes
          WHEEL_RIGHT repeatable script-message pan-image x +0.02 yes yes

          # align the border of the image to the border of the window
          # align-border takes the following arguments:
          # align-border ALIGN_X ALIGN_Y
          # any value for ALIGN_* is accepted, -1 and 1 map to the border of the window
          ctrl+shift+l script-message align-border -1 ""
          ctrl+shift+h  script-message align-border 1 ""
          ctrl+shift+j  script-message align-border "" -1
          ctrl+shift+k    script-message align-border "" 1

          # reset the image
          ctrl+0  no-osd set video-pan-x 0; no-osd set video-pan-y 0; no-osd set video-zoom 0

          + add video-zoom 0.5
          - add video-zoom -0.5; script-message reset-pan-if-visible
          = no-osd set video-zoom 0; script-message reset-pan-if-visible

          # sxiv compatibility
          w no-osd set video-unscaled yes; keypress =
          e no-osd set video-unscaled no; keypress =

          # h no-osd vf toggle hflip; show-text "Horizontal flip"
          # v no-osd vf toggle vflip; show-text "Vertical flip"

          r script-message rotate-video 90; show-text "Clockwise rotation"
          R script-message rotate-video -90; show-text "Counter-clockwise rotation"
          alt+r no-osd set video-rotate 0; show-text "Reset rotation"

          d script-message ruler

          # Toggling between pixel-exact reproduction and interpolation
          a cycle-values scale nearest ewa_lanczossharp

          # Toggle color management on or off
          c cycle icc-profile-auto

          # Screenshot of the window output
          S screenshot window

          # Toggle aspect ratio information on and off
          A cycle-values video-aspect "-1" "no"

          p script-message force-print-filename

          # playlist view
          g script-message playlist-view-toggle
        '';

        "mpv/mpv.conf".text = ''
          # MPV config

          # Every possible settings are explained here:
          # https://github.com/mpv-player/mpv/tree/master/DOCS/man

          ##################
          # VIDEO
          ##################
          # Video output

          osc=no # disable osc for custom osc
          x11-bypass-compositor=yes # bypass compositor
          demuxer-thread=yes

          # enable hardware acceleration
          hwdec=auto-safe
          vo=gpu
          profile=gpu-hq

          script-opts=osc-layout=slimbox
          scale=ewa_lanczossharp
          #scale=haasnsoft
          scale-radius=3
          cscale=ewa_lanczossoft
          opengl-pbo=yes
          fbo-format=rgba16f
          #opengl-shaders="~/.mpv/shaders/SSimSuperRes.glsl"
          #opengl-shaders="~/.mpv/shaders/SSimSuperRes.glsl,~/.mpv/shaders/adaptive-sharpen-2pass.glsl"
          #opengl-shaders="~/.mpv/shaders/adaptive-sharpen-2pass.glsl"
          icc-profile-auto=yes
          icc-cache-dir=/tmp/mpv-icc
          # target-brightness=100
          interpolation
          tscale=oversample
          video-sync=display-resample
          deband-iterations=2
          deband-range=12
          #no-deband
          temporal-dither=yes
          # no-border                               # no window title bar
          msg-module                              # prepend module name to log messages
          msg-color                               # color log messages on terminal
          # term-osd-bar                            # display a progress bar on the terminal
          use-filedir-conf                        # look for additional config files in the directory of the opened file                        # 'auto' does not imply interlacing-detection
          cursor-autohide-fs-only                 # don't autohide the cursor in window mode, only fullscreen
          cursor-autohide=1000                    # autohide the curser after 1s
          # fs-black-out-screens
          keep-open=yes

          # Video filters
          #vf=vapoursynth=~/.config/mpv/scripts/mvtools.vpy

          # Start in fullscreen
          # fullscreen

          # Activate autosync
          autosync=30

          # Skip some frames to maintain A/V sync on slow systems
          framedrop=vo

          # Force starting with centered window
          geometry=50%:50%
          autofit-larger=60%x60%
          autofit-smaller=10%x10%

          # Keep the player window on top of all other windows.
          ontop=yes

          # Disable screensaver
          stop-screensaver=yes

          # save position on quit
          # save-position-on-quit

          # Screenshot format
          screenshot-format=png
          screenshot-png-compression=0
          screenshot-png-filter=0
          screenshot-tag-colorspace=yes
          screenshot-high-bit-depth=yes
          screenshot-directory=~/Pictures/Screenshots


          # AUDIO
          alsa-resample=no
          audio-channels=2
          af=format=channels=2
          # volume=100
          # volume-max=230
          audio-pitch-correction=yes
          # audio-normalize-downmix=yes
          audio-display=no

          #user agent for playback
          user-agent = "Mozilla/5.0"

          # osd
          osd-on-seek=bar

          # SUBTITLES

          demuxer-mkv-subtitle-preroll            # try to correctly show embedded subs when seeking
          sub-auto=fuzzy                          # external subs don't have to match the file name exactly to autoload
          sub-file-paths=ass:srt:sub:subs:subtitles    # search for external subs in the listed subdirectories
          embeddedfonts=yes                       # use embedded fonts for SSA/ASS subs
          sub-fix-timing=no                       # do not try to fix gaps (which might make it worse in some cases)
          sub-ass-force-style=Kerning=yes             # allows you to override style parameters of ASS scripts

          sub-scale-by-window=yes

          # sub-text-font='PT Sans Tight'
          # sub-text-bold=yes
          # sub-text-margin-y=40
          ## sub-text-margin-x=160

          sub-font-size=45
          sub-color="#ffffffff"
          sub-border-color="#000000"
          sub-border-size=3.0
          sub-shadow-offset=0.5
          sub-shadow-color="#000000"

          # Change subtitle encoding. For Arabic subtitles use 'cp1256'.
          # If the file seems to be valid UTF-8, prefer UTF-8.
          sub-codepage=utf8

          # Languages

          slang=en,eng,enm,de,deu,ger             # automatically select these subtitles (decreasing priority)
          alang=en,eng,de,deu,ger       # automatically select these audio tracks (decreasing priority)

          # ytdl
          ytdl=yes
          hls-bitrate=max                         # use max quality for HLS streams
          # ytdl-format=0/(bestvideo[vcodec=vp9]/bestvideo[height>720]/bestvideo[height<=1080]/bestvideo[fps>30])[tbr<13000]+(bestaudio[acodec=vorbis]/bestaudio)/best
          # ytdl-format=0/(bestvideo[vcodec=vp9]/bestvideo[height>720]/bestvideo[height<=1080]/bestvideo[fps>30])[tbr<13000]+(bestaudio[acodec=vorbis]/bestaudio)/best
          ytdl-format=bestvideo[height<=?720][fps<=?30][vcodec!=?vp9]+bestaudio/best
          # protocol config
          [protocol.http]
          force-window=immediate
          [protocol.https]
          #profile=protocol.http
          [protocol.ytdl]
          profile=protocol.http

          # Audio-only content
          [audio]
          force-window=no
          no-video
          ytdl-format=bestaudio/best

          # Extension config, mostly for .webm loop
          [extension.webm]
          loop-file=inf
          [extension.gif]
          loop-file=inf
          [extension.jpeg]
          loop-file=inf
          [extension.png]
          loop-file=inf
          [extension.jpg]
          loop-file=inf
          [extension.gifv]
          loop-file=inf
        '';
    };
  };
}
