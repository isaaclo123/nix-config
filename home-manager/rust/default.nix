{ pkgs, ... }:

{
  home.sessionPath = ["$HOME/.cargo/bin"];

  home.packages = [
    # pkgs.rust-bin.stable.latest.default.override {
    #   extensions = [
    #     "rust-src"
    #     "rust-std"
    #     "clippy-preview"
    #     "rust-analysis"

    #     "rls-preview"
    #     "rustfmt-preview"
    #   ];
    # }
    # pkgs.rust-bin.stable.latest.default
    pkgs.rustup

  ];
}
