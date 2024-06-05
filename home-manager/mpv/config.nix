{ pkgs, ...}: {
  programs.mpv = {
    config = {
      # MPV config

      # https://github.com/hl2guide/better-mpv-config/blob/master/mpv.conf

      ##################
      # VIDEO
      ##################
      # Video output

      osc=false; # disable osc for custom osc
      osc-bar=false;
      border=false;
      video-sync="display-resample";
      script-opts="ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";

      x11-bypass-compositor=true; # bypass compositor
      demuxer-thread=true;

      ytdl=true;

      # Force starting with centered window
      geometry="50%:50%";
      autofit-larger="60%x60%";
      autofit-smaller="10%x10%";

      # Keep the player window on top of all other windows.
      ontop=true;

      # Keep open
      keep-open=true;

      # Disable screensaver
      stop-screensaver=true;

      # save position on quit
      # save-position-on-quit

      # Screenshot format
      screenshot-format="png";
      screenshot-png-compression=0;
      screenshot-png-filter=0;
      screenshot-tag-colorspace=true;
      screenshot-high-bit-depth=true;
      screenshot-directory="~/Pictures/Screenshots";


      # AUDIO
      alsa-resample=false;
      audio-channels=2;
      af="format=channels=2";
      # volume=100
      # volume-max=230
      audio-pitch-correction=true;
      # audio-normalize-downmix=yes
      audio-display=false;

      #user agent for playback
      user-agent = "Mozilla/5.0";

      # osd
      osd-on-seek="bar";

      # SUBTITLES

      demuxer-mkv-subtitle-preroll=true;            # try to correctly show embedded subs when seeking
      sub-auto="fuzzy";                          # external subs don't have to match the file name exactly to autoload
      sub-file-paths="ass:srt:sub:subs:subtitles";    # search for external subs in the listed subdirectories
      embeddedfonts=true;                       # use embedded fonts for SSA/ASS subs
      sub-fix-timing=false;                       # do not try to fix gaps (which might make it worse in some cases)
      sub-ass-force-style="Kerning=yes";             # allows you to override style parameters of ASS scripts

      sub-scale-by-window=true;

      # sub-text-font='PT Sans Tight'
      # sub-text-bold=yes
      # sub-text-margin-y=40
      ## sub-text-margin-x=160

      sub-font-size=42;
      sub-color="#ffffffff";
      sub-border-color="#000000";
      sub-border-size=3.0;
      sub-shadow-offset=0.5;
      sub-shadow-color="#000000";

      # Change subtitle encoding. For Arabic subtitles use 'cp1256'.
      # If the file seems to be valid UTF-8, prefer UTF-8.
      sub-codepage="utf8";

      # Languages

      slang="en,eng,enm,de,deu,ger";             # automatically select these subtitles (decreasing priority)
      alang="en,eng,de,deu,ger";       # automatically select these audio tracks (decreasing priority)

      hls-bitrate="max";                         # use max quality for HLS streams

      ## CONFIG SETTINGS

      # Uses GPU-accelerated video output by default.
      vo="gpu";
      # Can cause performance problems with some drivers and GPUs.
      profile="gpu-hq,M60";

      # ===== REMOVE THE ABOVE LINES AND RESAVE IF YOU ENCOUNTER PLAYBACK ISSUES =====

      # Source: https://github.com/hl2guide/better-mpv-config

      # Saves the seekbar position on exit
      save-position-on-quit=true;

      # Uses a large seekable RAM cache even for local input.
      cache="yes";
      # cache-secs=300
      # Uses extra large RAM cache (needs cache=yes to make it useful).
      demuxer-max-bytes="800M";
      demuxer-max-back-bytes="200M";
      # Sets volume to 70%.
      volume=70;

      af-add="dynaudnorm=g=5:f=250:r=0.9:p=0.5";
    };
  };
}
