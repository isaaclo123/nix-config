{ pkgs, lib, specialArgs, ...}: 
{
  programs.wofi = {
    enable = true;
  };

  xdg.configFile."wofi/colors".source = ./colors;
  xdg.configFile."wofi/config".source = lib.mkForce ./config;
  xdg.configFile."wofi/style.css".source = lib.mkForce ./style.css;
}
