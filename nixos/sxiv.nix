{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sxiv
  ];

  home-manager.users.isaac = {
    xresources.properties = {
      "Sxiv.background" = "black";
      "Sxiv.foreground" = "white";
      "Sxiv.font" = "GohuFont:pixelsize=14";
    };
  };
}
