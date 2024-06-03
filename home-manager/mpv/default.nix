{ pkgs, ...}: {
  imports = [
    ./config.nix
    ./bindings.nix
    ./profiles.nix
  ];
  programs.mpv = {
    enable = true;
  };
}
