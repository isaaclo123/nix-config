{ pkgs, specialArgs, ...}: 

let
  inherit (specialArgs) turn_off_non_bedroom_lights_on_resume;
in

let turn_off_non_bedroom_lights = pkgs.writeShellScriptBin "turn_off_non_bedroom_lights"
  ''
    RUN_SCRIPT=${if specialArgs?turn_off_non_bedroom_lights_on_resume then "true" else "false"}

    if $RUN_SCRIPT; then
      curl -X POST -H "Authorization: Bearer $(pass show hass-cli-pc)" -H "Content-Type: application/json" -d '{"entity_id": "automation.turn_off_non_bedroom_lights"}' http://10.0.0.125:8123/api/services/automation/trigger
    fi
  ''
; in

{
  home.packages = [ turn_off_non_bedroom_lights ];

  wayland.windowManager.hyprland.systemd.variables = ["--all"];
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lockCmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
         timeout = 900;
         on-timeout = "hyprctl dispatch dpms off";
         on-resume = "hyprctl dispatch dpms on";
        }
        {
         timeout = 1600;
         on-timeout = "hyprlock";
        }
        {
         timeout = 900;
         on-resume = "turn_off_non_bedroom_lights";
        }
      ];
    };
  };
}
