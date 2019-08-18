{ config, pkgs, stdenv, ... }:

let mpv-config = (pkgs.writeText "mpv.conf" ''
  # MPV config

  # Every possible settings are explained here:
  # https://github.com/mpv-player/mpv/tree/master/DOCS/man

  ##################
  # VIDEO
  ##################
  # Video output

  osc=no # disable osc for custom osc
  script-opts=osc-layout=slimbox
  profile=opengl-hq
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
  hwdec=no
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

  # Enable hardware decoding if available.
  #hwdec=cuda

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

  # osd shit
  #osd-font-size=20
  #osd-color="#ffffffff"
  #osd-border-color="#ff151515"
  #osd-border-size=2
  #osd-shadow-offset=1
  #osd-shadow-color="#11000000"
  #osd-fractions
  osd-on-seek=bar

  # SUBTITLES

  demuxer-mkv-subtitle-preroll            # try to correctly show embedded subs when seeking
  sub-auto=fuzzy                          # external subs don't have to match the file name exactly to autoload
  sub-file-paths=ass:srt:sub:subs:subtitles    # search for external subs in the listed subdirectories
  embeddedfonts=yes                       # use embedded fonts for SSA/ASS subs
  sub-fix-timing=no                       # do not try to fix gaps (which might make it worse in some cases)
  sub-ass-force-style=Kerning=yes             # allows you to override style parameters of ASS scripts

  sub-scale-by-window=yes


  # Makes .srt not shit
  #1
  # sub-font='Montara'
  # sub-font-size=54
  # sub-margin-y=45
  # sub-color="#ffffffff"
  # sub-border-color="#000000"
  # sub-border-size=2.4
  # sub-shadow-offset=0
  # sub-shadow-color="#000000"
  #2
  # sub-text-font='PT Sans Tight'
  # sub-text-bold=yes
  sub-font-size=45
  # sub-text-margin-y=40
  ## sub-text-margin-x=160
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
  # protocol shit
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

  # Extension shit, mostly for .webm loop
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
''); in

let autosave-plugin = pkgs.fetchurl {
  url = "https://gist.githubusercontent.com/Hakkin/5489e511bd6c8068a0fc09304c9c5a82/raw/7a19f7cdb6dd0b1c6878b41e13b244e2503c15fc/autosave.lua";
  sha256 = "0jxykk3jis2cplysc0gliv0y961d0in4j5dpd2fabv96pfk6chdd";
}; in

let autospeed-plugin = pkgs.fetchurl {
  url = "https://raw.githubusercontent.com/kevinlekiller/mpv_scripts/master/autospeed/autospeed.lua";
  sha256 = "18m0lzf0gs3g0mfgwfgih6mz98v5zcciykjl7jmg9rllwsx8syjl";
}; in

let autoloop-plugin = pkgs.fetchurl {
  url = "https://raw.githubusercontent.com/zc62/mpv-scripts/master/autoloop.lua";
  sha256 = "1g60h3c85ladx3ksixqnmg2cmpr68li38sgx167jylmgiavfaa6v";
}; in

# let gallery-dl-hook-plugin = pkgs.fetchurl {
#   url = "https://raw.githubusercontent.com/jgreco/mpv-scripts/master/gallery-dl_hook.lua";
#   sha256 = "1asc35rkqb1nn6yhdaf9rra6d6f9qj5a3i8hn0aw2aby3qwib87a";
# }; in

let gallery-dl_hook-plugin = (pkgs.writeText "gallery-dl_hook.lua" ''
  -- gallery-dl_hook.lua
  --
  -- load online image galleries as playlists using gallery-dl
  -- https://github.com/mikf/gallery-dl
  --
  -- to use, prepend the gallery url with: gallery-dl://
  -- e.g.
  --     `mpv gallery-dl://https://imgur.com/....`

  local utils = require 'mp.utils'
  local msg = require 'mp.msg'

  local function exec(args)
      local ret = utils.subprocess({args = args})
      return ret.status, ret.stdout, ret
  end

  mp.add_hook("on_load", 15, function()
      local url = mp.get_property("stream-open-filename", "")
      if (url:find("gallery%-dl://") ~= 1) then
          msg.debug("not a gallery-dl:// url: " .. url)
          return
      end
      local url = string.gsub(url,"gallery%-dl://","")

      local es, urls, result = exec({"gallery-dl", "-g", url})
      if (es < 0) or (urls == nil) or (urls == "") then
          msg.debug("failed to get album list.")
          urls = url
      end

      -- mp.commandv("loadlist", "memory://" .. urls)
      mp.commandv("loadlist", "memory://" .. urls)
  end)
''); in

let mpv-thumbnail-config = (pkgs.writeText "mpv_thumbnail_script.conf" ''
  # The thumbnail cache directory.
  # On Windows this defaults to %TEMP%\mpv_thumbs_cache,
  # and on other platforms to /tmp/mpv_thumbs_cache.
  # The directory will be created automatically, but must be writeable!
  # Use absolute paths, and take note that environment variables like %TEMP% are unsupported (despite the default)!
  cache_directory=/tmp/mpv_thumbs_cache
  # THIS IS NOT A WINDOWS PATH. COMMENT IT OUT OR ADJUST IT YOURSELF.

  # Whether to generate thumbnails automatically on video load, without a keypress
  # Defaults to yes
  autogenerate=yes

  # Only automatically thumbnail videos shorter than this (in seconds)
  # You will have to press T (or your own keybind) to enable the thumbnail previews
  # Set to 0 to disable the check, ie. thumbnail videos no matter how long they are
  # Defaults to 3600 (one hour)
  autogenerate_max_duration=3600

  # Use mpv to generate thumbnail even if ffmpeg is found in PATH
  # ffmpeg is slightly faster than mpv but lacks support for ordered chapters in MKVs,
  # which can break the resulting thumbnails. You have been warned.
  # Defaults to yes (don't use ffmpeg)
  prefer_mpv=yes

  # Explicitly disable subtitles on the mpv sub-calls
  # mpv can and will by default render subtitles into the thumbnails.
  # If this is not what you wish, set mpv_no_sub to yes
  # Defaults to no
  mpv_no_sub=no

  # Enable to disable the built-in keybind ("T") to add your own, see after the block
  disable_keybinds=no

  # The maximum dimensions of the thumbnails, in pixels
  # Defaults to 200 and 200
  thumbnail_width=200
  thumbnail_height=200

  # The thumbnail count target
  # (This will result in a thumbnail every ~10 seconds for a 25 minute video)
  thumbnail_count=150

  # The above target count will be adjusted by the minimum and
  # maximum time difference between thumbnails.
  # The thumbnail_count will be used to calculate a target separation,
  # and min/max_delta will be used to constrict it.

  # In other words, thumbnails will be:
  # - at least min_delta seconds apart (limiting the amount)
  # - at most max_delta seconds apart (raising the amount if needed)
  # Defaults to 5 and 90, values are seconds
  min_delta=5
  max_delta=90
  # 120 seconds aka 2 minutes will add more thumbnails only when the video is over 5 hours long!

  # Below are overrides for remote urls (you generally want less thumbnails, because it's slow!)
  # Thumbnailing network paths will be done with mpv (leveraging youtube-dl)

  # Allow thumbnailing network paths (naive check for "://")
  # Defaults to no
  thumbnail_network=yes
  # Override thumbnail count, min/max delta, as above
  remote_thumbnail_count=60
  remote_min_delta=15
  remote_max_delta=120

  # Try to grab the raw stream and disable ytdl for the mpv subcalls
  # Much faster than passing the url to ytdl again, but may cause problems with some sites
  # Defaults to yes
  remote_direct_stream=yes
''); in

let mpv-thumbnail-client-plugin = pkgs.fetchurl {
  url = "https://github.com/TheAMM/mpv_thumbnail_script/releases/download/0.4.2/mpv_thumbnail_script_client_osc.lua";
  sha256 = "1g8g0l2dfydmbh1rbsxvih8zsyr7r9x630jhw95jwb1s1x8izrr7";
}; in

let mpv-thumbnail-server-plugin = pkgs.fetchurl {
  url = "https://github.com/TheAMM/mpv_thumbnail_script/releases/download/0.4.2/mpv_thumbnail_script_server.lua";
  sha256 = "12flp0flzgsfvkpk6vx59n9lpqhb85azcljcqg21dy9g8dsihnzg";
}; in

let playlistnoplayback-plugin = pkgs.fetchurl {
  url = "https://raw.githubusercontent.com/422658476/MPV-EASY-Player/master/portable-data/scripts/playlistnoplayback.lua";
  sha256 = "035zsm4z349m920b625zly7zaz361972is55mg02xvgpv0awclfl";
}; in

let reload-plugin = pkgs.fetchurl {
  url = "https://raw.githubusercontent.com/4e6/mpv-reload/2b8a719fe166d6d42b5f1dd64761f97997b54a86/reload.lua";
  sha256 = "0dyx22rr1883m2lhnaig9jdp7lpjydha0ad7lj9pfwlgdr2zg4b9";
}; in

let youtube-quality-plugin = pkgs.fetchurl {
  url = "https://raw.githubusercontent.com/jgreco/mpv-youtube-quality/d03278f07bd8e202845f4a8a5b7761d98ad71878/youtube-quality.lua";
  sha256 = "0fi1b4r5znp2k2z590jrrbn6wirx7nggjcl1frkcwsv7gmhjl11l";
}; in

let mpv-socket = "/tmp/mpv-scratchpad-socket"; in
let fullscreen-lock = "/tmp/mpv-scratchpad-fullscreen.lock"; in

let mpv-scratchpad = (pkgs.writeShellScriptBin "mpv-scratchpad" ''
  SOCKET=${mpv-socket}
  FULLSCREEN=${fullscreen-lock}
  rm -f $FULLSCREEN
  mpv --input-ipc-server=$SOCKET --title=mpvscratchpad --x11-name=mpvscratchpad --geometry=512x288-32+62 --no-terminal --force-window --keep-open=yes --idle=yes
  '');
in
let mpv-scratchpad-toggle = (pkgs.writeShellScriptBin "mpv-scratchpad-toggle" ''
  VISIBLE_IDS=$(xdotool search --onlyvisible --classname 'mpvscratchpad')
  ID=$(xdotool search --classname 'mpvscratchpad' | head -n1)
  FULLSCREEN=${fullscreen-lock}

  # sticky desktop
  bspc node $ID --flag sticky=on

  # toggle hide
  bspc node $ID --flag hidden

  ## if hidden, don't do anything
  # [ -z $VISIBLE_IDS ] && exit 0

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
''); in
let mpv-scratchpad-ctl = (pkgs.writeShellScriptBin "mpv-scratchpad-ctl" ''
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
  [ "$1" = "restart" ] && command 'seek' "0" 'absolute'
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
  [ "$1" = "replace" ] && shift &&
      for video in "$@"; do
          command 'loadfile' "$video" 'replace';
      done;

''); in
let mpv-scratchpad-open = (pkgs.writeShellScriptBin "mpv-scratchpad-open" ''
  mpv-scratchpad-ctl replace "$@"
  mpv-scratchpad-ctl play
  exit 0
''); in
let mpv-scratchpad-fullscreen-toggle = (pkgs.writeShellScriptBin "mpv-scratchpad-fullscreen-toggle" ''
  VISIBLE_IDS=$(xdotool search --onlyvisible --classname 'mpvscratchpad')
  ID=$(xdotool search --classname 'mpvscratchpad' | head -n1)
  FULLSCREEN=${fullscreen-lock}

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
''); in
let mpv-scratchpad-hide = (pkgs.writeShellScriptBin "mpv-scratchpad-hide" ''
  ID=$(xdotool search --classname 'mpvscratchpad' | head -n1)

  mpv-scratchpad-ctl pause
  bspc node $ID --flag sticky=on
  bspc node $ID --flag hidden=on
  exit 0
''); in

{
  environment.systemPackages = with pkgs; [
    (mpv-with-scripts.override {
      scripts = [
        # (mpvScripts.mpris)
        # (mpvScripts.autocrop)
        autosave-plugin
        autospeed-plugin
        autoloop-plugin
        gallery-dl_hook-plugin
        playlistnoplayback-plugin
        mpv-thumbnail-client-plugin
        mpv-thumbnail-server-plugin
        reload-plugin
        youtube-quality-plugin
      ];
    })
    (mpv-scratchpad)
    (mpv-scratchpad-toggle)
    (mpv-scratchpad-fullscreen-toggle)
    (mpv-scratchpad-hide)
    (mpv-scratchpad-open)
    unstable.gallery-dl
    mpv-scratchpad-ctl
    mpvc
  ];

  home-manager.users.isaac = {
    xdg.configFile = {
      "mpv/mpv.conf".source = mpv-config;
      "mpv/script-opts/mpv_thumbnail_script.conf".source = mpv-thumbnail-config;
    };
  };
}
