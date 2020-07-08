{ pkgs, ... }:

let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };

  rust = (nixpkgs.latest.rustChannels.nightly.rust.override {
    extensions = [
      "rust-src"
      "rls-preview"
      "rust-analysis"
      "rustfmt-preview"
    ];
  });
in

with nixpkgs;

{
  environment.variables = {
    RUST_SRC_PATH = "${stdenv.mkDerivation {
      inherit (rustc) src;
      inherit (rustc.src) name; phases = ["unpackPhase" "installPhase"];
      installPhase = "cp -r src $out";
    }}";
  };

  environment.systemPackages = with nixpkgs; [
    rust
    pkgs.rustracer
    latest.rustChannels.nightly.cargo
    latest.rustChannels.nightly.rustc
  ];
}
