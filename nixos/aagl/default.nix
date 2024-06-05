# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports =
    [ # Include the results of the hardware scan.
      inputs.aagl.nixosModules.default
    ];

  programs.anime-game-launcher.enable = true;

  nix.settings = inputs.aagl.nixConfig;
}
