{ pkgs, ...}: {
  home.packages = [
    pkgs.libnotify
  ];
  services.dunst = {
    enable = true;

    configFile = ./dunstrc;
  };
}
