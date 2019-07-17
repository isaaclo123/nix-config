{ config, pkgs, stdenv, ... }:

let
  unstable = import <unstable> {};
in

# with import <nixpkgs> {};

let autosave-plugin = pkgs.fetchurl {
  url = "https://gist.githubusercontent.com/Hakkin/5489e511bd6c8068a0fc09304c9c5a82/raw/7a19f7cdb6dd0b1c6878b41e13b244e2503c15fc/autosave.lua";
  sha256 = "0jxykk3jis2cplysc0gliv0y961d0in4j5dpd2fabv96pfk6chdd";
}; in

let autospeed-plugin = pkgs.fetchurl {
  url = "https://raw.githubusercontent.com/kevinlekiller/mpv_scripts/master/autospeed/autospeed.lua";
  sha256 = "18m0lzf0gs3g0mfgwfgih6mz98v5zcciykjl7jmg9rllwsx8syjl";
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

# let mpv-scripts = [
#   autosave-plugin
#   autospeed-plugin
#   gallery-dl_hook-plugin
# ]; in

# let mpv-scripts-list = list: (
#
# ); in
#

let MPV_SOCKET = "/tmp/mpvsocket"; in
let
  mpv-scratchpad = (pkgs.writeShellScriptBin "mpv-scratchpad" ''
  SOCKET="${MPV_SOCKET}"

  mpv --x11-name=mpvscratchpad --geometry=512x288-40+60 --no-terminal --no-border --force-window --input-ipc-server="${MPV_SOCKET}" --idle=yes
  '');
in
let
  mpv-scratchpad-add = (pkgs.writeShellScriptBin "mpv-scratchpad-add" ''
  mpvc -a -S "${MPV_SOCKET}" "gallery-dl://$@"
  '');
in
let mpv-scratchpad-toggle = (pkgs.writeShellScriptBin "mpv-scratchpad-toggle" ''
  VISIBLE_IDS=$(xdotool search --onlyvisible --classname 'mpvscratchpad' | wc -l)
  ID=$(xdotool search --classname 'mpvscratchpad' | head -n1);\

  bspc node $ID --flag hidden;bspc node -f $ID
  [[ $VISIBLE_IDS == 0 ]] && bspc node --focus last
''); in
let
  mpv-scratchpad-ctl = (pkgs.writeShellScriptBin "mpv-scratchpad-ctl" ''
  ME=$(basename $0)
  TIMEOUT=5

  if [ "$1" = "previous" ]; then
      if pidof -o %PPID -x $ME; then # already running
          # go to previous video
          mpvc --seek -1
          killall -o 1s $ME
      else
          # otherwise restart video
          mpvc --time 0
      fi

      sleep $TIMEOUT
      exit 0
  fi

  if [ "$1" = "next" ]; then
      # next
      mpvc --seek 1
      mpvc --play
  fi

  if [ "$1" = "play" ]; then
      # play
      mpvc --play
  fi

  if [ "$1" = "pause" ]; then
      mpvc --stop
  fi

  if [ "$1" = "play-pause" ]; then
      # play toggle
      mpvc --toggle
  fi

  if [ "$1" = "toggle" ]; then
      id=$(cat /tmp/mpvscratchid);\
      bspc node $id --flag hidden;bspc node -f $id
  fi

  if [ "$1" = "stop" ]; then
      mpvc --stop
      # hide
      bspc query -N -n .floating > /tmp/mpvscratchid
  fi

  # reset mpvctlhelper "restart"
  killall $ME ||
  exit 0
  '');
in

{
  home.packages = with pkgs; [
    (mpv-scratchpad)
    (mpv-scratchpad-toggle)
    (mpv-scratchpad-ctl)
    unstable.gallery-dl
    # mpv-with-scripts
    jshon
    mpvc
  ];

  programs.mpv = {
    enable = true;
    config = {
      osc = false;
      script-opts = "osc-layout=slimbox";
      profile = "opengl-hq";
      scale = "ewa_lanczossharp";
      #scale=haasnsoft
      scale-radius = 3;
      cscale = "ewa_lanczossoft";
      opengl-pbo = true;
      fbo-format = "rgba16f";
      #opengl-shaders="~/.mpv/shaders/SSimSuperRes.glsl"
      #opengl-shaders="~/.mpv/shaders/SSimSuperRes.glsl,~/.mpv/shaders/adaptive-sharpen-2pass.glsl"
      #opengl-shaders="~/.mpv/shaders/adaptive-sharpen-2pass.glsl"
      icc-profile-auto = true;
      icc-cache-dir = "/tmp/mpv-icc";
      # target-brightness=100
      interpolation = true;
      tscale = "oversample";
      hwdec = false;
      video-sync = "display-resample";
      deband-iterations = 2;
      deband-range = 12;
      #no-deband
      temporal-dither = true;
      # no-border                               # no window title bar
      msg-module = true;                             # prepend module name to log messages
      msg-color = true;                              # color log messages on terminal
      # term-osd-bar                            # display a progress bar on the terminal
      use-filedir-conf = true;                       # look for additional config files in the directory of the opened file                        # 'auto' does not imply interlacing-detection
      cursor-autohide-fs-only = true;                # don't autohide the cursor in window mode, only fullscreen
      cursor-autohide = "1000";                    # autohide the curser after 1s
      # fs-black-out-screens
      keep-open = true;

      # Video filters
      #vf=vapoursynth=~/.config/mpv/scripts/mvtools.vpy

      # Start in fullscreen
      # fullscreen

      # Activate autosync
      autosync = 30;

      # Skip some frames to maintain A/V sync on slow systems
      framedrop = "vo";

      # Force starting with centered window
      geometry = "50%:50%";
      autofit-larger = "60%x60%";
      autofit-smaller = "10%x10%";

      # Keep the player window on top of all other windows.
      ontop = true;

      # Disable screensaver
      stop-screensaver = true;

      # save position on quit
      # save-position-on-quit

      # Enable hardware decoding if available.
      #hwdec=cuda

      # Screenshot format
      screenshot-format = "png";
      screenshot-png-compression = 0;
      screenshot-png-filter = 0;
      screenshot-tag-colorspace  = true;
      screenshot-high-bit-depth  = true;
      screenshot-directory = "~/Pictures/Screenshots";


      # AUDIO
      alsa-resample = false;
      audio-channels = 2;
      af = "format=channels=2";
      # volume=100
      # volume-max=230
      audio-pitch-correction = true;
      # audio-normalize-downmix=yes
      audio-display = false;

      #user agent for playback
      user-agent = "Mozilla/5.0";

      # osd config
      #osd-font-size=20
      #osd-color="#ffffffff"
      #osd-border-color="#ff151515"
      #osd-border-size=2
      #osd-shadow-offset=1
      #osd-shadow-color="#11000000"
      #osd-fractions
      osd-on-seek = "bar";

      # SUBTITLES

      demuxer-mkv-subtitle-preroll = true;            # try to correctly show embedded subs when seeking
      sub-auto="fuzzy";                          # external subs don't have to match the file name exactly to autoload
      sub-file-paths = "ass:srt:sub:subs:subtitles";    # search for external subs in the listed subdirectories
      embeddedfonts = true;                       # use embedded fonts for SSA/ASS subs
      sub-fix-timing = false;                       # do not try to fix gaps (which might make it worse in some cases);
      sub-ass-force-style = "Kerning=yes";             # allows you to override style parameters of ASS scripts

      sub-scale-by-window = true;


      # Makes .srt not config
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
      sub-font-size = 45;
      # sub-text-margin-y=40
      ## sub-text-margin-x=160
      sub-color = "#ffffffff";
      sub-border-color = "#000000";
      sub-border-size = "3.0";
      sub-shadow-offset = "0.5";
      sub-shadow-color="#000000";

      # Change subtitle encoding. For Arabic subtitles use 'cp1256'.
      # If the file seems to be valid UTF-8, prefer UTF-8.
      sub-codepage = "utf8";

      # Languages

      slang = "en,eng,enm,de,deu,ger";             # automatically select these subtitles (decreasing priority)
      alang = "en,eng,de,deu,ger";       # automatically select these audio tracks (decreasing priority)

      # ytdl
      ytdl = true;
      hls-bitrate = "max";                         # use max quality for HLS streams
      # ytdl-format=0/(bestvideo[vcodec=vp9]/bestvideo[height>720]/bestvideo[height<=1080]/bestvideo[fps>30])[tbr<13000]+(bestaudio[acodec=vorbis]/bestaudio)/best
      # ytdl-format=0/(bestvideo[vcodec=vp9]/bestvideo[height>720]/bestvideo[height<=1080]/bestvideo[fps>30])[tbr<13000]+(bestaudio[acodec=vorbis]/bestaudio)/best
      ytdl-format = "bestvideo[height<=?720][fps<=?30][vcodec!=?vp9]+bestaudio/best";
    };

    profiles = {
      "protocol.http" = {
        force-window = "immediate";
      };
      # [protocol.https]
      #profile=protocol.http
      "protocol.ytdl" = {
        profile = "protocol.http";
      };

      # Audio-only content
      audio = {
        force-window = false;
        no-video = "";
        ytdl-format = "bestaudio/best";
      };

      # Extension config, mostly for .webm loop
      "extension.webm" = {
        loop-file = "inf";
      };
      "extension.gif" = {
        loop-file = "inf";
      };
      "extension.jpeg" = {
        loop-file = "inf";
      };
      "extension.png" = {
        loop-file = "inf";
      };
      "extension.jpg" = {
        loop-file = "inf";
      };
      "extension.gifv" = {
        loop-file = "inf";
      };

    };
  };

  xdg.configFile = {
    "mpv/scripts/autosave.lua".source = autosave-plugin ;
    "mpv/scripts/autospeed.lua".source = autospeed-plugin ;
    "mpv/scripts/gallery-dl_hook.lua".source = gallery-dl_hook-plugin;
  };
}
