# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  homedir = (import ./settings.nix).homedir;
  username = (import ./settings.nix).username;

  home-manager =
    fetchTarball https://github.com/rycee/home-manager/archive/release-20.03.tar.gz;

  nixos-hardware =
    fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;

  unstable =
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
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
      ./lisp.nix
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

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
  '';

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
    # extraConfig = ''
    #   [General]
    #   Enable=Source,Sink,Media,Socket
    #   AutoConnectTimeout = 0
    #   IdleTimeout=0
    #   DiscoverableTimeout = 0
    #   PairableTimeout = 0
    #   PageTimeout = 8192
    # '';
  };

  hardware.trackpoint = {
    enable = true;
    device = "ETPS/2 Elantech TrackPoint";
    sensitivity = 255;
    speed = 255;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];

    daemon = {
      config = {
        realtime-scheduling = "yes";
      };
    };
    support32Bit = true;

    extraConfig = ''
      .ifexists module-udev-detect.so
        load-module module-udev-detect tsched=0
      .else

      #load-module module-suspend-on-idle timeout=30
    '';
  };

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
  time.timeZone = "America/Los_Angeles";

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

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

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

  location.provider = "geoclue2";

  services.geoclue2 = {
    enable = true;
    enable3G = false;
    enableCDMA = false;
    enableDemoAgent = false;
    enableModemGPS = false;
    enableNmea = false;
    enableWifi = true;
  };

  services.avahi = {
    enable = true;
  };

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
    extraGroups = [ "wireshark" "docker" "uucp" "adbusers" "wheel" "video" "audio" "disk" "networkmanager" "sudo" ]; # Enable ‘sudo’ for the user.
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

    services.udiskie = {
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
  system.stateVersion = "20.03"; # Did you read the comment?
  nixpkgs.config = {
    # pulseaudio = true;
    allowBroken = true;
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstable {
        config = config.nixpkgs.config;
      };

      nixos-hardware = import nixos-hardware {
        config = config.nixpkgs.config;
      };
    };
  };

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
    #   extra-builtins-file = /etc/nixos/extra-builtins.nix
    extraOptions = ''
      allow-unsafe-native-code-during-evaluation = true
    '';
  };
}
