# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "dd94a849df69fe62fe2cb23a74c2b9330f1189ed"; # CHANGEME
    ref = "release-18.09";
  };
in

let hardware-configuration =
  fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
in

let unstable =
  fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in

{
  imports =
    [ # Include the results of the hardware scan.
      "${hardware-configuration}/lenovo/thinkpad/t480s"
      "${home-manager}/nixos"

      ./hardware-configuration.nix
      ./bspwm.nix
      ./sxhkd.nix
      ./vim.nix
      ./zsh.nix
      ./compton.nix
      ./slock.nix

      # home-manager
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
      ./todo.nix
      ./zathura.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    }
  ];

  networking.hostName = "client1"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # fonts
  fonts = {
    fonts = with pkgs; [
      # noto-fonts-emoji
      unifont
      unifont_upper
      gohufont
      siji
      font-awesome_4
      # dejavu_fonts
    ];
    fontconfig = {
      enable = true;
      allowBitmaps = true;
      useEmbeddedBitmaps = true;
      antialias = true;
      defaultFonts = {
        monospace = [ "GohuFont" ];
        sansSerif = [ "GohuFont" ];
        serif     = [ "GohuFont" ];
      };
      ultimate = {
        enable = false;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages =
    let
      reload-desktop = (with import <nixpkgs> {}; writeShellScriptBin "reload-desktop" ''
        pkill -USR1 -x sxhkd
        pkill -USR1 -x compton
        systemctl --user restart polybar
        # polybar-ext
        bspc wm -r
      '');
    in
    with pkgs; [
      # custom packages
      (reload-desktop)
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
      ranger
      firefox
      neofetch
      scrot
      gimp
      sxiv

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

      jmtpfs

      openshot-qt
      gtk-engine-murrine
      gtk_engines

      alsa-firmware
      alsaUtils
      alsaTools
      alsaLib
      alsaOss
      zita-alsa-pcmi
    ];

  hardware.brightnessctl.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # dconf for themes
  services.dbus.packages = with pkgs; [ gnome3.dconf ];

  # flatpak
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the clipmenu daemon
  services.clipmenu.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # sound.extraConfig = ''
  #   pcm.!default {
  #     type hw
  #     card 1
  #   }

  #   ctl.!default {
  #     type hw
  #     card 0
  #   }
  # '';
  hardware.pulseaudio = {
    # package = pkgs.pulseaudioFull;
    enable = true;
    support32Bit = true;
    # systemWide = true;
    # tcp.enable = true;
    # configFile = pkgs.writeText "default.pa" ''
    #   load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    # '';
    # configFile = pkgs.runCommand "default.pa" {} ''
    #   sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
    #     ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
    # '';
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";

    desktopManager.xterm.enable = false;

    displayManager = {
      lightdm.autoLogin = {
        enable = true;
        user = "isaac";
      };
    };

    # Enable touchpad support.
    libinput.enable = true;
  };

  # enable ssd fstrim
  services.fstrim.enable = true;

  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;

  users.users.isaac = {
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ]; # Enable ‘sudo’ for the user.
    group = "users";
    home = "/home/isaac";
    isNormalUser = true;
    uid = 1000;
  };

  home-manager.users.isaac = {
    xsession.pointerCursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
    };

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
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstable {
        config = config.nixpkgs.config;
      };
    };
  };
}
