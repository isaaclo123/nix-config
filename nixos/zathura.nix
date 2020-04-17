{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  color = (import ./settings.nix).color;
in

{
  environment.systemPackages = with pkgs; [
    (zathura.override {
      useMupdf = true;
    })
  ];

  home-manager.users."${username}" = {
    xdg.configFile = {
      "zathura/zathurarc".text = ''
        set recolor-darkcolor "#${color.fg}"
        set recolor-lightcolor "#${color.bg}"
        set recolor true

        # colors
        set statusbar-fg "#${color.gray}"
        set statusbar-bg "#${color.darkgray}"

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
