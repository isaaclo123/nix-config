# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports =
    [ # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.home-manager
    ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs; 
    };
    users = {
      isaac = import ../../home-manager/desktop-home.nix;
    };
  };
}
