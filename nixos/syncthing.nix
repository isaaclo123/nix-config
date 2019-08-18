{ pkgs, ... }:

{
  services.syncthing = {
    configDir = "/home/isaac";
    dataDir = "/home/isaac";
    group = "isaac";
  };
}
