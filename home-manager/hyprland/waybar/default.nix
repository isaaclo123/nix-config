{ lib, pkgs, ...}: {
  programs.waybar = {
    enable = true;
    package = pkgs.old.waybar;
  };
  xdg.configFile."waybar/config".source = lib.mkForce ./config;
  xdg.configFile."waybar/style.css".source = lib.mkForce ./style.css;
}
