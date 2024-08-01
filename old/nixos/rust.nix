{ pkgs, ... }:

{
  home.packages = [
    pkgs.rust-bin.stable.latest.override
    {
      extensions = [
        "rust-src"
        # "rust-std"
        # "clippy-preview"
        # "rust-analysis"

        # "rls-preview"
        # "rustfmt-preview"
      ];

    }
  ];
}
