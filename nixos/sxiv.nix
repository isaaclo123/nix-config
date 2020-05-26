{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  font = (import ./settings.nix).font;
in

{
  environment.systemPackages = with pkgs; [
    sxiv
  ];

  home-manager.users."${username}" = {
    xresources.properties = {
      "Sxiv.background" = "black";
      "Sxiv.foreground" = "white";
      "Sxiv.font" = "${font.mono}:size=${builtins.toString font.size}";
    };
  };
}
