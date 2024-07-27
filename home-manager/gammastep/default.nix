{pkgs, ...}: {
  services.gammastep = {
    enable = true;
    # provider = "geoclue2";
    provider = "manual";
    dawnTime = "6:00-7:45";
    duskTime = "18:35-20:15";
    temperature.night = 3000;
  };
}
