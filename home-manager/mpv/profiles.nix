{ pkgs, ...}: {
  programs.mpv = {
    profiles = {
      ## PROFILE

      # Custom Profiles
      # Uses specific naming convensions for shorter easier typing.
      # Naming Convensions:
      # V = Very Low, L = Low, M = Medium, H = High, U = Ultra, S = Supreme
      # Very Low = 480p, Low = 720p, Medium = 1080p, High = 1440p, Ultra = 2160p (4K), Supreme = 4320p (8K)
      # 30 = 30 frames per second, 60 = 60 frames per second
      # Use the switch e.g: --profile=H60
      # 4320p (8K) 60 FPS
      S60 = {
        ytdl-format="bestvideo[height<=?4320][fps<=?60][vcodec!=?vp9]+bestaudio/best";
      };
      # 4320p (8K) 30 FPS
      S30 = {
        ytdl-format="bestvideo[height<=?4320][fps<=?30][vcodec!=?vp9]+bestaudio/best";
      };
      # 2160p (4K) 60 FPS
      U60 = {
        ytdl-format="bestvideo[height<=?2160][fps<=?60][vcodec!=?vp9]+bestaudio/best";
      };
      # 2160p (4K) 30 FPS
      U30 = {
        ytdl-format="bestvideo[height<=?2160][fps<=?30][vcodec!=?vp9]+bestaudio/best";
      };
      # 1440p 60 FPS
      H60 = {
        ytdl-format="bestvideo[height<=?1440][fps<=?60][vcodec!=?vp9]+bestaudio/best";
      };
      # 1440p 30 FPS
      H30 = {
        ytdl-format="bestvideo[height<=?1440][fps<=?30][vcodec!=?vp9]+bestaudio/best";
      };
      # 1080p 60 FPS
      M60 = {
        ytdl-format="bestvideo[height<=?1080][fps<=?60][vcodec!=?vp9]+bestaudio/best";
      };
      # 1080p 30 FPS
      M30 = {
        ytdl-format="bestvideo[height<=?1080][fps<=?30][vcodec!=?vp9]+bestaudio/best";
      };
      # 720p 60 FPS
      L60 = {
        ytdl-format="bestvideo[height<=?720][fps<=?60][vcodec!=?vp9]+bestaudio/best";
      };
      # 720p 30 FPS
      L30 = {
        ytdl-format="bestvideo[height<=?720][fps<=?30][vcodec!=?vp9]+bestaudio/best";
      };
      # 480p 60 FPS
      V60 = {
        ytdl-format="bestvideo[height<=?480][fps<=?60][vcodec!=?vp9]+bestaudio/best";
      };
      # 480p 30 FPS
      V30 = {
        ytdl-format="bestvideo[height<=?480][fps<=?30][vcodec!=?vp9]+bestaudio/best";
      };

      ## AFTER VIDEO SETTINGS

      # protocol config
      "protocol.http" = {
        force-window="immediate";
      };
      "protocol.https" = {
        profile="protocol.http";
      };
      "protocol.ytdl" = {
        profile="protocol.http";
      };

      # Audio-only content
      audio = {
        force-window=false;
        no-video=true;
        ytdl-format="bestaudio/best";
      };

      # Extension config, mostly for .webm loop
      "extension.webm" = {
        loop-file="inf";
        osd-scale=1;
        osd-font-size=55;
      };
      "extension.gif" = {
        cache=false;
        loop-file="inf";
      };
      "extension.jpeg" = {
        loop-file="inf";
      };
      "extension.png" = {
        loop-file="inf";
      };
      "extension.jpg" = {
        loop-file="inf";
      };
      "extension.gifv" = {
        loop-file="inf";
      };
    };
  };
}
