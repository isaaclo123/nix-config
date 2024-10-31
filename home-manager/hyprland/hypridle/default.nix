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

let dpms_off = pkgs.writeShellScriptBin "dpms_off"
''
  touch /tmp/dpms_off

  while [ -f /tmp/dpms_off ]; do
    hyprctl dispatch dpms off
    sleep 1
  done
''; in

{
  home.packages = [ turn_off_non_bedroom_lights dpms_off ];

  wayland.windowManager.hyprland.systemd.variables = ["--all"];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lockCmd = "pidof hyprlock || hyprlock";
        unlockCmd = "killall hyprlock; turn_off_non_bedroom_lights";
      };

      listener = [

        {
         timeout = 10;
         on-timeout = "pidof hyprlock && hyprctl dispatch dpms off"; # turns off the screen if hyprlock is active
         on-resume = "pidof hyprlock && hyprctl dispatch dpms on";    # command to run when activity is detected after timeout has fired.
        }
        {
         timeout = 500;
         on-timeout = "hyprctl dispatch dpms off";
         on-resume = "hyprctl dispatch dpms on";
        }
        {
         timeout = 1500;
         on-timeout = "loginctl lock-session";
        }
        {
         timeout = 60;
         on-resume = "turn_off_non_bedroom_lights";
        }
        {
         timeout = 2200;
         on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
