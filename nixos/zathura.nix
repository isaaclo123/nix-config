{ pkgs, ... }:

let username = (import ./settings.nix).username; in

{
  environment.systemPackages = with pkgs; [
    (zathura.override {
      useMupdf = true;
    })
  ];

  home-manager.users."${username}" = {
    xdg.configFile = {
      "zathura/zathurarc".text = ''
        set recolor-darkcolor "#ffffff"
        set recolor-lightcolor "#202746"
        set recolor true

        # colors
        set statusbar-fg "#f5f7ff"
        set statusbar-bg "#293256"

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
