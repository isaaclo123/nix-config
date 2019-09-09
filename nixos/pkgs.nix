{ pkgs, ... }:

{
  environment.systemPackages =
    let
      wn = (pkgs.writeShellScriptBin "wn" ''
        NOTE=$(date +%Y-%m-%d)

        for ARG in "$@"
        do
            NOTE="$NOTE-$ARG"
        done

        NOTE+='.md'
        vim $NOTE
      '');

      alarm = (pkgs.writeShellScriptBin "alarm" ''
        song=$(find ~/Music -iname "*.mp3" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.ogg" | shuf | head -n1)
        date=''${*}
        echo Okay! Will ring you on $(date --date="$date").
        sleep $(( $(date --date="$date" +%s) - $(date +%s) ));
        echo Wake up!
        mpv --no-config --loop=inf "$song"
      '');

    in with pkgs; [
      # custom packages
      (import ./z.nix)
      (import ./rofimoji.nix)
      (wn)
      (alarm)
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

      squashfsTools

      ansible
      sshpass

      bc

      bfg-repo-cleaner

      go-mtpfs

      steam

      gcc

      networkmanagerapplet

      unoconv
    ];
}
