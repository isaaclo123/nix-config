{ pkgs, lib, specialArgs, ...}: 
let
  inherit (specialArgs) monitors;
in
{
  imports = [
    ./wofi/default.nix
    ./waybar/default.nix
    ./sway-osd/default.nix
    ./hyprpaper/default.nix
    ./wlogout/default.nix
    ./hyprlock/default.nix
    ./hypridle/default.nix
  ];

  home.packages = with pkgs; [brightnessctl wev hyprshot];

  home.sessionVariables = {
    HYPRSHOT_DIR = "$HOME/Pictures/Screenshots";
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = if specialArgs?monitors then (map
        (m:
          let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position  = "${toString m.x}x${toString m.y}";
          in
          "${m.name},${resolution},${position},1"
        )
        (monitors)) else ",preferred,auto,1";

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 100;
        workspace_swipe_min_speed_to_force = 5;
        workspace_swipe_cancel_ratio = 0.1;
        workspace_swipe_touch = true;
        workspace_swipe_invert = true;
      };

      #autostart
      exec-once = [
        "waybar"
        "calcurse --daemon"
      ];

      exec = [
        "turn_off_non_bedroom_lights"
      ];

      decoration.rounding = 4;

      general = {
        border_size = 3;
      };

      misc = {
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
      };

      # unscale XWayland
      xwayland = {
        force_zero_scaling = true;
      };

      cursor = {
        inactive_timeout = 10;
        # no_cursor_warps = true;
      };

      env = [
        "QUTE_QT_WRAPPER, PyQt6"
        "QT_QPA_PLATFORM, wayland"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "QT_SCALE_FACTOR_ROUNDING_POLICY, RoundPreferFloor"
      ];

      "$mod" = "SUPER";
      "$terminal" = "kitty";

      dwindle = {
        pseudotile = true; # master switch for pseudotiling
        preserve_split = true;
      };

      master = {
      	new_status = "master";
      };

      input = {
        kb_options="ctrl:nocaps,altwin:swap_alt_win";
        scroll_factor="0.2";
      };
      
      windowrule = [
        # "float,^(mpv)$"
        "tile,^(mpv)$"
        "suppressevent fullscreen,^(mpv)$"
        "suppressevent maximize,^(mpv)$"
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bind = [
        # Screenshot a window
        "$mod, PRINT, exec, HYPRSHOT_DIR=$HOME/Pictures/Screenshots hyprshot -m window"
        "$mod, END, exec, HYPRSHOT_DIR=$HOME/Pictures/Screenshots hyprshot -m window"
        # Screenshot a monitor
        ", PRINT, exec, HYPRSHOT_DIR=$HOME/Pictures/Screenshots hyprshot -m output"
        ", END, exec, HYPRSHOT_DIR=$HOME/Pictures/Screenshots hyprshot -m output"
        # Screenshot a region
        "SHIFT $mod, PRINT, exec, HYPRSHOT_DIR=$HOME/Pictures/Screenshots hyprshot -m region"
        "SHIFT $mod, END, exec, HYPRSHOT_DIR=$HOME/Pictures/Screenshots hyprshot -m region"

        "$mod, D, exec, pkill wofi || wofi --show=drun"
        "$mod, RETURN, exec, $terminal"
        "$mod SHIFT, Q, killactive"
        "$mod CTRL, E, exec, pkill wlogout || wlogout"
        "$mod, SPACE, togglefloating"
        "$mod, B, exec, qutebrowser"
        "$mod, F, fullscreen"
        "$mod, S, pseudo" # dwindle
        "$mod, V, togglesplit" # dwindle

        "$mod, DELETE, exec, hyprlock" # sleep

	# move focus
        "$mod, h, movefocus, l"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        "$mod, l, movefocus, r"

	# move window 
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"
        "$mod SHIFT, l, movewindow, r"

	# workspace
	"$mod, 1, workspace, 1"
	"$mod, 2, workspace, 2"
	"$mod, 3, workspace, 3"
	"$mod, 4, workspace, 4"
	"$mod, 5, workspace, 5"
	"$mod, 6, workspace, 6"
	"$mod, 7, workspace, 7"
	"$mod, 8, workspace, 8"
	"$mod, 9, workspace, 9"
	"$mod, 0, workspace, 10"

	# move to workspace
 	"$mod SHIFT, 1, movetoworkspace, 1"
	"$mod SHIFT, 2, movetoworkspace, 2"
	"$mod SHIFT, 3, movetoworkspace, 3"
	"$mod SHIFT, 4, movetoworkspace, 4"
	"$mod SHIFT, 5, movetoworkspace, 5"
	"$mod SHIFT, 6, movetoworkspace, 6"
	"$mod SHIFT, 7, movetoworkspace, 7"
	"$mod SHIFT, 8, movetoworkspace, 8"
	"$mod SHIFT, 9, movetoworkspace, 9"
	"$mod SHIFT, 0, movetoworkspace, 10"

	# toggle special workspace
	"$mod, TAB, togglespecialworkspace, magic"
	"$mod SHIFT, TAB, movetoworkspace, special:magic"
      ];

      bindel = [
       	# resize window 
        "$mod ALT, l, resizeactive, 10 0"
        "$mod ALT, h, resizeactive, -10 0"
        "$mod ALT, k, resizeactive, 0 -10"
        "$mod ALT, j, resizeactive, 0 10"

        # zephyrus-g14
        ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"

        ", XF86KbdBrightnessUp, exec, asusctl -n"
        ", XF86KbdBrightnessDown, exec, asusctl -p"

        # "XF86Launch4, exec, asusctl led-mode -n"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"


        # Sink volume toggle mute
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        # Source volume toggle mute
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
        
        # Volume raise with custom value
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        # Volume lower with custom value
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        
        # Brightness raise
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        # Brightness lower
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
      ];

      # bindl = [
      #   ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      # ];
    };
  };
}
