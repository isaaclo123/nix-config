{ pkgs, ...}: {
  imports = [
    ./email.nix
    ./neomutt.nix
  ];
}
