{ pkgs, lib, ... }:

let
  color = (import ./settings.nix).color;
  theme = (import ./settings.nix).theme;
  spacing = (import ./settings.nix).spacing;
in

let autostarted-status = "/tmp/autostarted-status.lock"; in

{
  environment.systemPackages =
    let logout-desktop = (pkgs.writeShellScriptBin "logout-desktop" ''
      #!/bin/bash
      rm -f ${autostarted-status}
      mpc pause &>/dev/null
      bspc quit
    ''); in

    let reload-desktop = (pkgs.writeShellScriptBin "reload-desktop" ''
      # pkill -USR1 -x sxhkd
      killall sxhkd
      sxhkd -c /etc/sxhkdrc &
      bspc wm -r

      systemctl --user restart polybar
      systemctl --user restart compton
      systemctl --user restart dunst

      betterlockscreen -u ${theme.wallpaper} &
      bat cache --build &
    ''); in

    with pkgs; [
      (reload-desktop)
      (logout-desktop)
      bspwm
      autocutsel
    ];

  services.xserver.windowManager = {
    bspwm = {
      enable = true;
      configFile = "/etc/bspwmrc";
    };
  };

  environment.etc.bspwmrc = {
    mode = "0755";
    text = ''
      #!/usr/bin/env bash

      # CONFIG
      LAPTOP_MONITOR='eDP-1'
      LAPTOP_MONITOR_RESOLUTION=1920x1080

      LAPTOP_MONITOR_WITH_EXT_RESOLUTION=1600x900
      EXTERNAL_MONITOR_OFFSET=1600x0

      EXTERNAL_MONITOR=$(xrandr --query | grep ' connected' | grep -v $LAPTOP_MONITOR | head -n1 | cut -d ' ' -f1)

      if [[ -z "$EXTERNAL_MONITOR" ]]; then
        # if not external monitor
        xrandr --output $LAPTOP_MONITOR --primary --mode $LAPTOP_MONITOR_RESOLUTION --auto --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off

        bspc desktop 8 -m $LAPTOP_MONITOR
        bspc desktop 9 -m $LAPTOP_MONITOR
        bspc desktop 0 -m $LAPTOP_MONITOR

        bspc monitor $LAPTOP_MONITOR -d 1 2 3 4 5 6 7 8 9 0
      else
        # if there is external monitor
        EXTERNAL_MONITOR_RESOLUTION=$(xrandr --query | awk -v a=$LAPTOP_MONITOR '/ connected/{if ($1 == a) next; else getline; print $1; exit;}')

        xrandr --output $LAPTOP_MONITOR --primary --mode $LAPTOP_MONITOR_WITH_EXT_RESOLUTION --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off
        xrandr --output $EXTERNAL_MONITOR --mode $EXTERNAL_MONITOR_RESOLUTION --pos $EXTERNAL_MONITOR_OFFSET --rotate normal --right-of $LAPTOP_MONITOR
        bspc desktop 8 -m $EXTERNAL_MONITOR
        bspc desktop 9 -m $EXTERNAL_MONITOR
        bspc desktop 0 -m $EXTERNAL_MONITOR

        bspc monitor $LAPTOP_MONITOR -d 1 2 3 4 5 6 7
        bspc monitor $EXTERNAL_MONITOR -d 8 9 0
      fi

      systemctl --user restart polybar.service

      # Config
      bspc config remove_disabled_monitors true
      bspc config remove_unplugged_monitors true
      bspc config merge_overlapping_monitors true

      bspc config border_width ${toString spacing.border}
      bspc config window_gap ${toString spacing.padding}

      bspc config focused_border_color \#${color.white}
      bspc config active_border_color \#${color.darkgray}
      bspc config normal_border_color \#${color.black}
      bspc config presel_feedback_color \#${color.cyan}

      bspc config split_ratio          0.52
      # bspc config borderless_monocle   true
      bspc config gapless_monocle      false
      bspc config focus_follows_pointer false

      # rules

      bspc rule -a Rofi state=floating
      bspc rule -a Zathura state=tiled
      # bspc rule -a libreoffice state=tiled

      bspc rule -a termite_ desktop='^2'
      bspc rule -a vim_ desktop='^3'
      bspc rule -a ranger_ desktop='^4'
      bspc rule -a neomutt_ desktop='^5'
      bspc rule -a ncmpcpp_ desktop='^6'
      bspc rule -a weechat_ desktop='^7'

      bspc rule -a mpv state=floating
      bspc rule -a mpv:mpvscratchpad sticky=on state=floating hidden=on border=off

      bspc rule -a termitescratchpad sticky=on state=floating hidden=on

      bspc rule -a termiteopen sticky=on state=floating

      # always autostart
      xinput set-prop "ETPS/2 Elantech TrackPoint" "libinput Accel Speed" 0.5
      xinput set-prop "ETPS/2 Elantech Touchpad" "libinput Accel Speed" 0.5
      feh --bg-scale "${theme.wallpaper}"

      # only autostart on beginning
      if [ ! -f ${autostarted-status} ]; then
        calcurse --daemon

        autocutsel -s CLIPBOARD -fork
        autocutsel -s PRIMARY -fork

        # window autostart
        qutebrowser &
        termite --class=termite_ &
        #termite --class=vim_ -e "zsh -ci vim" &
        #termite --class=ranger_ -e "zsh -ci ranger" &
        #termite --class=neomutt_ -e "zsh -ci neomutt" &
        #termite --class=ncmpcpp_ -e ncmpcpp &
        termite --class=vim_ -e vim &
        termite --class=ranger_ -e ranger &
        termite --class=neomutt_ -e neomutt &
        termite --class=ncmpcpp_ -e ncmpcpp &
        (sleep 20 && termite --class=weechat_ -e weechat) &

        (sleep 5 && systemctl restart --user "imapnotify-*.service") &

        termite-scratchpad &
        mpv-scratchpad &

        # NOTIFY=off bluetooth-toggle off &
        # NOTIFY=off touchpad-toggle off &
        NOTIFY=off touchscreen-toggle off &

        # create autostarted status file
        touch ${autostarted-status}
      fi
    '';
  };
}
