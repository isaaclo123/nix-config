{ config, pkgs, stdenv, ... }:

{
  environment.systemPackages = with pkgs; [
    syncthing
  ];

  # syncthing service
  services.syncthing = {
    enable = true;
    configDir = "/home/isaac";
    dataDir = "/home/isaac";
    user = "isaac";
    # group = "isaac";
  };
}
