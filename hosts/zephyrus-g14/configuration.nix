# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/default.nix
      ./nvidia/default.nix
      ../../nixos/steam/default.nix
      ../../nixos/stylix/default.nix
    ];

  programs.hyprland.enable = true;

  # udisk2
  services.udisks2.enable = true;

  # asusd
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # geoclue2
  services.avahi.enable = true;
  services.geoclue2 = {
    enable = true;
    enableWifi = true;
  };

  # audio
  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" "nvidia" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["amdgpu" "nvidia"];

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    amdgpuBusId = "PCI:4:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  boot.initrd.luks.devices."luks-ab9fcfa9-f400-4fe0-8c38-5eca10042f29".device = "/dev/disk/by-uuid/ab9fcfa9-f400-4fe0-8c38-5eca10042f29";
  networking.hostName = "zephyrus-g14"; # Define your hostname.
  # Enable automatic login for the user.
  services.getty.autologinUser = "isaac";
}
