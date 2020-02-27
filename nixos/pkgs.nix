{ pkgs, ... }:

{
  environment.systemPackages =
    let
      display-toggle = (pkgs.writeShellScriptBin "display-toggle" ''
        sleep 0.5 && xset dpms force off
      '');

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

      backup = (pkgs.writeShellScriptBin "backup.sh" ''
        #!${pkgs.bash}/bin/bash

        BACKUP="/run/media/isaac/TOSHIBA EXT"

        if [[ $UID != 0 ]]; then
            echo "Please run this script with sudo:"
            echo "sudo $0 $*"
            exit 1
        fi

        DATE=`date +%Y-%m-%d`
        BACKUP_NAME="''${DATE}-backup"
        BACKUP_DIR_NAME="''${BACKUP}/''${BACKUP_NAME}"

        declare -a folders=(
            # "/home/isaac/.local/share/buku"
            "/home/isaac/.calendars"
            "/home/isaac/.contacts"
            "/home/isaac/.weechat"

            "/home/isaac/.password-store"
            "/home/isaac/.gnupg"
            "/home/isaac/buku"
            "/home/isaac/DCIM"
            "/home/isaac/Documents"
            "/etc/nixos"
            "/home/isaac/Pictures"
            "/home/isaac/Music"
            "/home/isaac/Videos"
        )

        mkdir "$BACKUP_DIR_NAME"

        # get length of an array
        arraylength=''${#folders[@]}

        # use for loop to read all values and indexes
        for (( i=1; i<''${arraylength}+1; i++ ));
        do
            rsync -ah --progress "''${folders[$i-1]}" "$BACKUP_DIR_NAME"
        done
      '');

    in with pkgs; [
      # custom packages
      (import ./z.nix)
      (import ./rofimoji.nix)
      (wn)
      (alarm)
      (display-toggle)
      (ppt-to-pdf)
      (backup)
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

      # pandoc
      pandoc
      haskellPackages.pandoc-citeproc
      texlive.combined.scheme-full

      # dot
      graphviz

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
      zip
      xdotool

      # development tools
      firejail

      # c
      manpages
      gnumake
      clang
      pkg-config
      gdb
      gcc6
      # node
      nodejs
      nodePackages.node2nix
      jupyter
      jetbrains.jdk

      # network
      wireshark
      simplehttp2server
      heroku
      httpie
      insomnia

      binutils-unwrapped

      # storage
      jmtpfs
      squashfsTools
      go-mtpfs
      rclone

      # video
      openshot-qt

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
      unstable.multimc

      # xorg
      xorg.xhost
      xorg.xdpyinfo

      # aws
      aws
      awscli

      # bluetooth
      bluez-alsa
      blueman

      # audacity
      audacity

      # system
      # busybox
      pciutils
      unstable.skype
    ];
}
