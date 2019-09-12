# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let homedir = "/home/isaac"; in

let home-manager = builtins.fetchGit {
  url = "https://github.com/rycee/home-manager.git";
  rev = "dd94a849df69fe62fe2cb23a74c2b9330f1189ed"; # CHANGEME
  ref = "release-18.09";
}; in

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
      ./slock.nix
      ./pkgs.nix

      ./bat.nix
      ./sxiv.nix
      ./weechat.nix

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

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    }
  ];

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
  '';

  boot.blacklistedKernelModules = [ "snd_pcsp" ];
  boot.cleanTmpDir = true;

  # Enable sound.
  sound = {
    enable = true;
    enableOSSEmulation = true;
    # extraConfig = ''
    #   # pcm.rear cards.pcm.default
    #   # pcm.center_life cards.pcm.default
    #   # pcm.side cards.pcm.default

    #   pcm.!default {
    #     type hw
    #     card 0
    #   }
    # '';
  };
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

  hardware.opengl.driSupport32Bit = true;

  hardware.pulseaudio = {
    enable = true;
    daemon = {
      config = {
        realtime-scheduling = "yes";
      };
    };
    support32Bit = true;
  };

  security.rtkit.enable = true;

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

  fonts = {
    fonts = with pkgs; [
      # noto-fonts-emoji
      unifont
      unifont_upper
      gohufont
      font-awesome_4
      # dejavu_fonts
    ];

    fontconfig = {
      enable = true;
      allowBitmaps = true;
      useEmbeddedBitmaps = true;
      antialias = true;

      hinting = {
        enable = true;
      };

      defaultFonts = {
        monospace = [
          "GohuFont"
          # "Unifont"
          # "Unifont Upper"
        ];
        sansSerif = [
          "GohuFont"
        ];
        serif = [
          "GohuFont"
        ];
      };

      ultimate = {
        enable = false;
      };
    };

    enableDefaultFonts = true;
    enableFontDir = true;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  hardware.brightnessctl.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # compton
  services.compton = {
    enable = true;
    backend = "glx";

    shadow = true;
    shadowOffsets = [ (-6) (-6) ];
    shadowOpacity = "0.3";
    shadowExclude = [
      "name != 'mpvscratchpad'"
    ];

    vSync = "drm";
    extraOptions = ''
      shadow-radius = 4;
      paint-on-overlay = true;
    '';
  };

  # adb
  programs.adb.enable = true;

  # flatpak
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the clipmenu daemon
  services.clipmenu.enable = true;

  # docker
  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
    user = "isaac";
    # group = "isaac";
  };

  services.redshift = {
    enable = true;
    provider = "geoclue2";
    temperature = {
      day = 6000;
      night = 3000;
    };
  };

  # dbus for gtk theme
  services.dbus.packages = with pkgs; [ xfce.dconf ];

  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;

  users.users.isaac = {
    createHome = true;
    extraGroups = [ "docker" "uucp" "adbusers" "wheel" "video" "audio" "disk" "networkmanager" "sudo" ]; # Enable ‘sudo’ for the user.
    group = "users";
    home = "${homedir}";
    isNormalUser = true;
    uid = 1000;
  };

  home-manager.users.isaac = {
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
  system.stateVersion = "19.03"; # Did you read the comment?
  nixpkgs.config = {
    # pulseaudio = true;
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstable {
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
