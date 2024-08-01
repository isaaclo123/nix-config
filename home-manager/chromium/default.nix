{ pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;

    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      {
        id = "qwertyuiopasdfghjklzxcvbnmqwerty";
        crxPath = pkgs.fetchurl {
          url = "https://github.com/NeverDecaf/chromium-web-store/releases/download/v1.5.4.3/Chromium.Web.Store.crx";
          sha256 = "1j3ppn6j0aaqwyj5dyl8hdmjxia66dz1b4xn69h1ybpiz6p1r840";
        };
        version = "1.0";
      }
    ];
  };
}
