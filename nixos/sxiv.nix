{ pkgs, ... }:

let username = (import ./settings.nix).username; in

{
  environment.systemPackages = with pkgs; [
    sxiv
  ];

  home-manager.users."${username}" = {
    xresources.properties = {
      "Sxiv.background" = "black";
      "Sxiv.foreground" = "white";
      "Sxiv.font" = "GohuFont:pixelsize=14";
    };
  };
}
