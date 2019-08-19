{ config, pkgs, ... }:

with import <nixpkgs> {};

let ranger-derivation = stdenv.lib.overrideDerivation pkgs.ranger (oldAttrs : {
  src = fetchFromGitHub {
    owner = "ranger";
    repo = "ranger";
    rev = "ee344c896e85f92f91d097a95e88ae4ead786c7b";
    sha256 = "1j621vsjg8s221raf8v2x3db35zqlfwksqlv6wgq2krpmi729p35";
  };
}); in

{
  environment.systemPackages = with pkgs; [
    (ranger-derivation)
    imagemagick
    w3m
    ffmpegthumbnailer
    p7zip
    python37Packages.pdf2image
    odt2txt
  ];

  home-manager.users.isaac = {
    # xdg.configFile = {
    #   "ncmpcpp/config".source = ncmpcpp-config;
    #   "ncmpcpp/bindings".source = ncmpcpp-bindings;
    # };
  };
}
