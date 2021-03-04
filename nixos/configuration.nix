# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  homedir = (import ./settings.nix).homedir;
  username = (import ./settings.nix).username;
  nixos-version = (import ./settings.nix).nixos-version;

  nixos =
    fetchTarball "https://nixos.org/channels/nixos-${nixos-version}/nixexprs.tar.xz";

  # unstable =
  #   fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;

  # unstable = import <unstable> {};

  home-manager =
    fetchTarball "https://github.com/nix-community/home-manager/archive/release-${nixos-version}.tar.gz";

  nixos-hardware =
    fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
in

{
  imports =
    [ # Include the results of the hardware scan.
      # "${nixos-hardware}/lenovo/thinkpad/t480s"
      <nixos-hardware/lenovo/thinkpad/t480s>
      "${home-manager}/nixos"

      ./hardware-configuration.nix
      ./bspwm.nix
      ./compton.nix
      ./opengl.nix
      ./sxhkd.nix
      ./vim.nix
      ./zsh.nix
      ./lock.nix
      ./pkgs.nix

      ./bat.nix
      ./sxiv.nix
      ./weechat.nix

      # ./vpn.nix

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
      ./haskell.nix
      ./rust.nix
      ./r.nix
      ./email.nix
      ./termite.nix
      ./neomutt.nix
      ./calcurse.nix
      ./khard.nix
      ./vdirsyncer.nix
      ./todo.nix
      ./zathura.nix
      ./ranger.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    root = {
      # name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
    options v4l2loopback devices=1 exclusive_caps=1 video_nr=2 card_label="v4l2loopback"
  '';
  boot.initrd.kernelModules = [ "v412loopback" ];
  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  boot.cleanTmpDir = true;

  # Enable sound.
  sound = {
    enable = true;
    enableOSSEmulation = true;
  };

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    powerOnBoot = true;
    config = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        AutoConnectTimeout = 0;
        IdleTimeout = 0;
        DiscoverableTimeout = 0;
        PairableTimeout = 0;
        PageTimeout = 8192;
      };
    };
  };

  hardware.trackpoint = {
    enable = true;
    device = "ETPS/2 Elantech TrackPoint";
    sensitivity = 150;
    speed = 150;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];

  configFile = pkgs.runCommand "default.pa" {} ''
    sed 's/load-module module-suspend-on-idle$/#load-module module-suspend-on-idle/' \
      ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
  '';


    daemon = {
      config = {
        realtime-scheduling = "yes";
        default-fragments = 3;
        default-fragment-size-msec = 5;
        avoid-resampling = "yes";
        default-sample-rate = 48000;
      };
    };
    support32Bit = true;

    extraConfig = ''
      load-module module-switch-on-connect
      load-module module-bluetooth-policy
      load-module module-bluetooth-discover

      .ifexists module-udev-detect.so
        load-module module-udev-detect tsched=0
      .else

      load-module module-null-sink sink_name=rtp
      load-module module-rtp-send source=rtp.monitor

      set-default-sink rtp
      load-module module-rtp-recv
    '';
  };

  # services.jack = {
  #   jackd.enable = true;
  #   # support ALSA only programs via ALSA JACK PCM plugin
  #   alsa.enable = false;
  #   # support ALSA only programs via loopback device (supports programs like Steam)
  #   loopback = {
  #     enable = true;
  #     # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
  #     #dmixConfig = ''
  #     #  period_size 2048
  #     #'';
  #   };
  # };

  security.rtkit.enable = true;

  networking.hostName = "client1"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
    enable = true;  # Enables wireless support via wpa_supplicant.
    packages = with pkgs; [
      networkmanager-openvpn
    ];
  };

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # hardware.brightnessctl.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # services.synergy.server = {
  #   enable = true;
  #   autoStart = true;
  #   configFile = "/etc/synergy-server.conf";
  # };

  # fwupd
  services.fwupd = {
    enable = true;
  };

  # tor
  services.tor = {
    enable = true;
    client.enable = true;
  };

  # adb
  programs.adb.enable = true;

  # flatpak
  # services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # docker
  virtualisation.docker.enable = true;

  # virtualbox
  # virtualisation.virtualbox = {
  #   guest.enable = true;
  #   host = {
  #     enable = true;
  #     enableExtensionPack = true;
  #   };
  # };

  networking.firewall = {
    enable = true;
    checkReversePath = false; # https://github.com/NixOS/nixpkgs/issues/10101

    allowedTCPPorts = [
      24800 # synergy
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";

    desktopManager.xterm.enable = false;

    displayManager = {
      lightdm = {
        autoLogin = {
          enable = true;
          user = username;
        };
      };

      defaultSession = "none+bspwm";

      xpra.pulseaudio = true;
    };

    # Enable touchpad support.
    libinput.enable = true;
  };

  # enable ssd fstrim
  services.fstrim.enable = true;

  # syncthing service
  services.syncthing = {
    enable = true;
    configDir = "${homedir}/.config/syncthing";
    dataDir = "${homedir}";
    user = "${username}";
    # group = "isaac";
  };

  location = {
    # provider = "geoclue2";
    provider = "manual";
    latitude = 44.9;
    longitude = -93.3;
  };

  # services.localtime.enable = true;

  services.geoclue2 = {
    enable = true;
  };

  # services.avahi = {
  #   enable = true;
  # };

  services.redshift = {
    enable = true;
    temperature = {
      day = 6500;
      night = 4000;
    };
  };

  # dbus for gtk theme
  services.dbus.packages = with pkgs; [ xfce.dconf ];

  security.sudo.wheelNeedsPassword = false;

  # security.wrappers = {
  #   audacity = {
  #     source  = "${pkgs.audacity.out}/bin/audacity";
  #     owner   = "nobody";
  #     group   = "nogroup";
  #     capabilities = "cap_net_raw+ep";
  #   };
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;

  users.users."${username}" = {
    createHome = true;
    extraGroups = [ "wireshark" "docker" "uucp" "adbusers" "wheel" "video" "audio" "disk" "networkmanager" "sudo" ];
    group = "users";
    home = "${homedir}";
    isNormalUser = true;
    uid = 1000;
  };

  home-manager.users."${username}" = {
    # xsession.pointerCursor = {
    #   name = "Vanilla-DMZ";
    #   package = pkgs.vanilla-dmz;
    # };

    dconf.settings = {
      # set screen timeout to 20 min
      "org/gnome/desktop" = {
        idle-delay = 1200;
      };
    };

    services.udiskie = {
      tray = "never";
      enable = true;
      automount = true;
      notify = true;
    };

    services.unclutter = {
      enable = true;
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
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = nixos-version; # Did you read the comment?
  nixpkgs = {
    config = {
      # pulseaudio = true;
      allowBroken = false;
      allowUnfree = true;
      packageOverrides = pkgs: {
        nixos = import nixos {
          config = config.nixpkgs.config;
        };

        unstable = import <unstable> {
          config = config.nixpkgs.config;
        };

        nixos-hardware = import nixos-hardware {
          config = config.nixpkgs.config;
        };
      };
      permittedInsecurePackages = [
        "go-1.14.15"
      ];
    };

    # overlays = [
    #   (import ./overlays/aws-cli.nix)
    # ];
  };

  # Without any `nix.nixPath` entry:
  # nix.nixPath =
  #   # Prepend default nixPath values.
  #   # Append our nixpkgs-overlays.
  #   [ "nixpkgs-overlays=/etc/nixos/overlays/" ]
  # ;

  nix = {
    # auto garbage collect
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # auto optimize
    autoOptimiseStore = true;

    #   plugin-files = ${pkgs.nix-plugins.override { nix = config.nix.package; }}/lib/nix/plugins/libnix-extra-builtins.so
    extraOptions = ''
      allow-unsafe-native-code-during-evaluation = true
    '';
  };
}
