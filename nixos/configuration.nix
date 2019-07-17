# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/t480s>
      ./hardware-configuration.nix
      ./bspwm.nix
      ./sxhkd.nix
      # ./polybar.nix
      # ./termite.nix
      ./vim.nix
      ./zsh.nix
      # ./qutebrowser.nix
      # ./rofi.nix
      # ./rofi-pass.nix
      # ./offlineimap.nix
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
      noto-fonts-emoji
      # unifont
      gohufont
      siji
      font-awesome_4
      # dejavu_fonts
    ];
    fontconfig = {
      allowBitmaps = true;
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

  # environment.extraInit = ''
  #   # clipboard merge
  #   # autocutsel &
  #   # autocutsel -s PRIMARY &
  #   unclutter &
  # '';

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

      # pdf, pandoc
      zathura
      pandoc
      texlive.combined.scheme-full

      # mail
      # neomutt
      # isync
      # offlineimap
      # msmtp

      # organization
      todo-txt-cli

      # monitoring
      htop
      s-tui

      # desktop
      i3lock-pixeled
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

      # internet
      w3m-full

      # desktop utilities
      ranger
      firefox
      neofetch
      scrot
      gimp
      sxiv

      # unclutter
      # autocutsel

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
  hardware.pulseaudio.enable = true;

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

      # autostart
      # setupCommands = ''
      #   dunst &

      #   qutebrowser &
      #   termite --class=termite_ &
      #   termite --class=vim_ vim &
      #   termite --class=ranger_ ranger &
      #   termite --class=neomutt_ neomutt &
      #   termite --class-ncmpcpp_ ncmpcpp &
      # '';
    };

    # Enable touchpad support.
    libinput.enable = true;
  };

  services.compton = {
    enable = true;
    shadow = false;
    # shadowOffsets = [ (-9) (0) ];
    # shadowExclude = [
    #   "name = 'Polybar tray window'"
    #   "_GTK_FRAME_EXTENTS@:c"
    # ];
    # shadowOpacity = "0.5";
    # extraOptions = ''
    #   shadow-radius = 9;
    # '';
  };

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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

  nixpkgs.config = {
    allowUnfree = true;
  };
}
