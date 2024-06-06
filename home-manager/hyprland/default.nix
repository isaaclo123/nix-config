{ pkgs, lib, specialArgs, ...}: 
let
  inherit (specialArgs) monitors;
in
{
  imports = [
    ./waybar/default.nix
  ];

  home.packages = with pkgs; [wofi brightnessctl];

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
        (monitors)) else ",preferred,auto,auto";

      #autostart
      exec-once = [
        "waybar"
      ];

      # unscale XWayland
      xwayland = {
        force_zero_scaling = true;
      };

      general = {
        cursor_inactive_timeout = 10;
        no_cursor_warps = true;
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
      	new_is_master = true;
      };

      input = {
        kb_options="ctrl:nocaps";
      };

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bind = [
        "$mod, D, exec, pkill wofi || wofi --show=drun"
        "$mod, RETURN, exec, $terminal"
        "$mod SHIFT, Q, killactive"
        "$mod CTRL, E, exit"
        "$mod, SPACE, togglefloating"
        "$mod, B, exec, qutebrowser"
        "$mod, F, fullscreen"
        "$mod, S, pseudo" # dwindle
        "$mod, V, togglesplit" # dwindle


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
      ];

      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
    };
  };
}
