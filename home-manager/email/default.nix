{ pkgs, ...}: {
  imports = [
    ./email.nix
    ./neomutt/default.nix
  ];
}
