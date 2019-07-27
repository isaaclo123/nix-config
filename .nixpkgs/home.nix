{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./polybar.nix
      ./dunst.nix
      ./music.nix
      ./mpv.nix
      ./gpg.nix
      ./theme.nix
      ./qutebrowser.nix
      ./rofi.nix
      ./rofi-pass.nix
      ./python.nix
      ./email.nix
      ./termite.nix
      ./neomutt.nix
      ./calendar.nix
    ];

  home.packages = with pkgs; [
    openshot-qt
  ];

  services = {
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };
    unclutter = {
      enable = true;
    };
  };

  programs = {
    home-manager = {
      enable = true;
    };

    git = {
      enable = true;
      userEmail = "isaaclo123@gmail.com";
      userName = "isaaclo123";
    };
  };

  # xsession.pointerCursor = {
  #   name = "Vanilla-DMZ";
  #   package = pkgs.vanilla-dmz;
  #   # size = 128;
  # };

  # xdg.configFile = {
  #   # autostart
  #   "bspwm/autostart".source = (pkgs.writeText "config" ''
  #   '');
  # };
}
