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
        date="$@"
        echo Okay! Will ring you on $(date --date="$date").
        sleep $(( $(date --date="$date" +%s) - $(date +%s) ));
        echo Wake up!
        mpv --no-video --no-config --loop=inf "$song"
      '');

      ppt-to-pdf = (pkgs.writeShellScriptBin "ppt-to-pdf.sh" ''
        unoconv -f pdf *.{ppt,pptx} &&
        rm *.{ppt,pptx}
      '');

    in with pkgs; [
      # custom packages
      (import ./z.nix)
      (import ./rofimoji.nix)
      (wn)
      (alarm)
      (ppt-to-pdf)
      # (import ./xfd.nix)

      # office
      libreoffice
      unoconv

      # nix
      nix-prefetch-scripts
      home-manager

      # monitoring
      htop
      s-tui

      # desktop
      # i3lock-pixeled
      networkmanagerapplet
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
      bc

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
      # c
      manpages
      gnumake
      clang
      pkg-config
      gdb
      gcc
      # node
      nodejs
      # network
      wireshark
      simplehttp2server
      heroku

      # storage
      jmtpfs
      squashfsTools
      go-mtpfs
      rclone

      # video
      unstable.openshot-qt

      # themes
      gtk-engine-murrine
      gtk_engines
      lxappearance

      # ansible/ssh
      ansible
      sshpass

      # games
      unstable.steam
      unstable.lutris

      # xorg
      xorg.xhost
      xorg.xdpyinfo

      # aws
      aws
      awscli
    ];
}
