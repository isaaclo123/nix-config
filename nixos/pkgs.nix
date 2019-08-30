{ pkgs, ... }:

{
  environment.systemPackages =
    with pkgs; [
      # custom packages
      (import ./z.nix)
      # (import ./xfd.nix)
      # programming
      nodejs

      # office
      libreoffice

      # nix
      nix-prefetch-scripts
      home-manager

      # monitoring
      htop
      s-tui

      # desktop
      # i3lock-pixeled

      feh

      # password
      pass
      pass-otp

      # setting
      acpi
      arandr
      pavucontrol
      redshift
      xbrightness
      brightnessctl

      # desktop utilities
      # firefox
      neofetch
      scrot
      gimp

      # unclutter
      autocutsel

      # security
      clamav

      # storage
      udiskie
      ntfs3g

      # misc utilities
      killall
      wget
      git
      python
      unrar
      unzip
      xdotool

      # development tools
      gnumake
      clang
      pkg-config
      gdb

      jmtpfs

      openshot-qt
      gtk-engine-murrine
      gtk_engines
      lxappearance

      weechat

      squashfsTools

      ansible
      sshpass

      bc

      bfg-repo-cleaner

      go-mtpfs

      steam
    ];
}
