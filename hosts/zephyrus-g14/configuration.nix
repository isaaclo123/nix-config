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
      ../../nixos/desktop-configuration.nix
      ../../nixos/opengl/default.nix
      ../../nixos/nvidia/default.nix
      ../../nixos/steam/default.nix
      ../../nixos/stylix/default.nix
      ../../nixos/virt-manager/default.nix
      ./home.nix
    ];

  # asusd
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" "nvidia" ];
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    amdgpuBusId = "PCI:4:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  boot.initrd.luks.devices."luks-ab9fcfa9-f400-4fe0-8c38-5eca10042f29".device = "/dev/disk/by-uuid/ab9fcfa9-f400-4fe0-8c38-5eca10042f29";
  networking.hostName = "zephyrus-g14"; # Define your hostname.
  # Enable automatic login for the user.
  services.getty.autologinUser = "isaac";

  services.rabbitmq.enable = true;
}
