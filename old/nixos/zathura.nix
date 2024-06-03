{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  opacity = (import ./settings.nix).opacity;
  color = (import ./settings.nix).color;
in

{
  environment.systemPackages =
    # let
    #   girara-patched =
    #     (with import <nixpkgs> {};
    #       stdenv.lib.overrideDerivation girara (oldAttrs : {
    #         patches = oldAttrs.patches ++ [(fetchpatch {
    #             name = "girara-alpha.patch";
    #             url = "https://gist.githubusercontent.com/miseran/0ea4b95e9816bf915b7b7171a5a0e42d/raw/a592b122717fd2a0325241963ec18fd2a4d1ab37/girara-alpha.patch";
    #             sha256 = "1jdfar5y4nqyb77frc5k5lc5dhaapkf07gibx7p6h1l7q5vxzr15";
    #           })];
    #         }));

    #   zathura-patched =
    #     (with import <nixpkgs> {};
    #       stdenv.lib.overrideDerivation zathura (oldAttrs : {
    #           buildInputs = with pkgs; [
    #             zathura girara-patched mupdf cairo
    #           ];

    #           patches = oldAttrs.patches ++ [(fetchpatch {
    #               name = "zathura-alpha.patch";
    #               url = "https://gist.githubusercontent.com/miseran/0ea4b95e9816bf915b7b7171a5a0e42d/raw/a592b122717fd2a0325241963ec18fd2a4d1ab37/zathura-alpha.patch";
    #               sha256 = "1xn2m19yzasicsb26yvprrdlwmmbsdrknr22idk5i5qdwgj899x1";
    #             })];
    #           })); in
    with pkgs; [
      # (unstable.zathura.override {
      #   useMupdf = true;
      # })
      (unstable.zathura)
  ];

  home-manager.users."${username}" = {
    xdg.configFile = {
      "zathura/zathurarc".text = ''
        set recolor-darkcolor "#${color.alt.white}"
        set recolor-lightcolor ${opacity.background-transparent}
        set default-bg ${opacity.background-transparent}
        set recolor true

        # colors
        set statusbar-fg "#${color.white}"
        set statusbar-bg "#${color.bg}"

        # keybindings
        map [fullscreen] a adjust_window best-fit
        map [fullscreen] s adjust_window width
        map [fullscreen] f follow
        map [fullscreen] <Tab> toggle_index

        map c set recolor false
      '';
    };
  };
}
