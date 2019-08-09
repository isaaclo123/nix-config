{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pandoc
    texlive.combined.scheme-full
  ];

  home-manager.users.isaac = {
    programs.zathura = {
      enable = true;
      options = {

        recolor-darkcolor = "#ffffff";
        recolor-lightcolor = "#202746";
        recolor = true;

        # colors
        statusbar-fg = "#f5f7ff";
        statusbar-bg = "#293256";
      };

      extraConfig = ''
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
