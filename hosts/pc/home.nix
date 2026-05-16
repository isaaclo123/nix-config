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
      turn_off_non_bedroom_lights_on_resume = false;
      monitors = [
        {
            name = "DP-2"; #aoc
            width = 2560;
            height = 1440;
            refreshRate = 144;
            transform = 0;
            x=0;
            y=0;
        }
        {
            name = "HDMI-A-1"; #dell
            width = 1920;
            height = 1080;
            transform = 3;
            refreshRate = 60;
            x=2560;
            y=0;
        }
        # {
        #     name = "HDMI-A-1"; #asus
        #     width = 1920;
        #     height = 1080;
        #     refreshRate = 60;
        #     x=0;
        #     y=0;
        # }
      ];
      workspaces = [
        "1, monitor:DP-2"
        "2, monitor:DP-2"
        "3, monitor:DP-2"
        "4, monitor:DP-2"
        "5, monitor:DP-2"

        "6, monitor:HDMI-A-1"
        "7, monitor:HDMI-A-1"
        "8, monitor:HDMI-A-1"
        "9, monitor:HDMI-A-1"
        "10, monitor:HDMI-A-1"
      ];
    };
    users = {
      isaac = import ../../home-manager/desktop-home.nix;
    };
  };
}
