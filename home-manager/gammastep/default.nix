{pkgs, ...}: {
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature.night = 3000;
  };
}
