{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./polybar.nix
      ./dunst.nix
      ./music.nix
      ./mpv.nix
      ./qutebrowser.nix
      ./rofi.nix
      ./python.nix
      ./email.nix
      ./termite.nix
      ./neomutt.nix
    ];

  # home.packages = [
  # ];

  services = {
    gpg-agent = {
      enable = false;

      defaultCacheTtl = 2147483647;
      maxCacheTtl = 2147483647;

      defaultCacheTtlSsh = 2147483647;
      maxCacheTtlSsh = 2147483647;

      enableSshSupport = true;
    };
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
