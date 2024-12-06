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
      turn_off_non_bedroom_lights_on_resume = true;
      monitors = [
        {
            name = "DP-1"; #aoc
            width = 2560;
            height = 1440;
            refreshRate = 144;
            x=-960;
            y=1080;
        }
        {
            name = "HDMI-A-2"; #dell
            width = 1920;
            height = 1080;
            refreshRate = 60;
            x=-1920;
            y=0;
        }
        {
            name = "HDMI-A-1"; #asus
            width = 1920;
            height = 1080;
            refreshRate = 60;
            x=0;
            y=0;
        }
      ];
    };
    users = {
      isaac = import ../../home-manager/desktop-home.nix;
    };
  };
}
