{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sbcl

    lispPackages.quicklisp
    lispPackages.quicklisp-to-nix
    lispPackages.swank
  ];
}
