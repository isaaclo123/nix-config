{ config, pkgs, stdenv, ... }:

let
  unstable = import <unstable> {};
in

{
  home.packages = with pkgs; [
    # calendar/contacts
    unstable.calcurse
    vdirsyncer
    khard
  ];

  xdg.configFile = {
    # "mpv/scripts/gallery-dl_hook.lua".source = gallery-dl_hook-plugin;
  };
}
