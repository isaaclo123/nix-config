{ pkgs, ...}: {
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
         # on-resume = "hyprctl dispatch dpms on";
        }
        {
         timeout = 1600;
         on-timeout = "hyprlock";
        }
      ];
    };
  };
}
