{ pkgs, ... }:

let
  # moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  moz_overlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  # moz_overlay = import ((import <nixpkgs> {}).fetchFromGitHub {
  #   owner = "mozilla";
  #   repo = "nixpkgs-mozilla";
  #   rev = "e912ed483e980dfb4666ae0ed17845c4220e5e7c";
  #   sha256 = "08fvzb8w80bkkabc1iyhzd15f4sm7ra10jn32kfch5klgl0gj3j3";
  # });
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };

  rust = (nixpkgs.latest.rustChannels.stable.rust.override {
    extensions = [
      "rust-src"
      "rust-std"
      "clippy-preview"
      "rust-analysis"

      "rls-preview"
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
    # latest.rustChannels.nightly.cargo
    # latest.rustChannels.nightly.rustc
    latest.rustChannels.stable.cargo
    latest.rustChannels.stable.rustc
  ];
}
