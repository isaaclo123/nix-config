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
      ../../nixos/steam/default.nix
      ../../nixos/stylix/default.nix
      ../../nixos/virt-manager/default.nix
      ./home.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = ["amdgpu" ];

  boot.initrd.luks.devices."luks-b65bf4f8-f57c-4ecc-baf9-8a30932a1b97".device = "/dev/disk/by-uuid/b65bf4f8-f57c-4ecc-baf9-8a30932a1b97";

  networking.hostName = "t14s"; # Define your hostname.
  # Enable automatic login for the user.
  services.getty.autologinUser = "isaac";

  hardware.enableRedistributableFirmware = true;
}
