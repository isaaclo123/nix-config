{ pkgs, lib, ... }:

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
      pkill -USR1 -x sxhkd
      pkill -USR1 -x compton
      systemctl --user restart polybar
      bspc wm -r
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

    default = "bspwm";
  };

  environment.etc.bspwmrc = {
    mode = "0755";
    text = ''
      #!/usr/bin/env bash

      # spread desktops
      desktops=10
      count=$(xrandr -q | grep ' connected' | wc -l)
      i=1
      for m in $(xrandr -q | grep ' connected' | awk '{print $1}'); do
        sequence=$(seq $(((1+($i-1)*$desktops/$count))) $(($i*$desktops/$count)))
        bspc monitor $m -d $(echo ''${sequence} | sed 's/10/0/')
        i=$(($i+1))
      done
      # bspc monitor -d 1 2 3 4 5 6 7 8 9 10

      bspc config border_width         4
      bspc config window_gap          14

      bspc config focused_border_color \#6679cc
      bspc config active_border_color \#c76b29
      bspc config normal_border_color \#293256
      bspc config presel_feedback_color \#6679cc

      bspc config split_ratio          0.52
      bspc config borderless_monocle   true
      bspc config gapless_monocle      false
      bspc config focus_follows_pointer false

      # rules

      bspc rule -a Rofi state=floating
      bspc rule -a Zathura state=tiled

      bspc rule -a termite_ desktop='^2'
      bspc rule -a vim_ desktop='^3'
      bspc rule -a ranger_ desktop='^4'
      bspc rule -a neomutt_ desktop='^5'
      bspc rule -a ncmpcpp_ desktop='^6'
      bspc rule -a weechat_ desktop='^7'

      bspc rule -a mpv state=floating
      bspc rule -a mpv:mpvscratchpad sticky=on state=floating hidden=on border=off

      # always autostart
      killall -q dunst && (dunst &)
      feh --bg-scale /etc/nixos/wallpaper.jpg
      calcurse --daemon

      # only autostart on beginning
      if [ ! -f ${autostarted-status} ]; then
        autocutsel -fork
        autocutsel -selection PRIMARY -fork

        # window autostart
        qutebrowser &
        termite --class=termite_ &
        termite --class=vim_ -e vim &
        termite --class=ranger_ -e ranger &
        termite --class=neomutt_ -e neomutt &
        termite --class=ncmpcpp_ -e ncmpcpp &
        termite --class=weechat_ -e weechat &

        mpv-scratchpad &

        NOTIFY=off bluetooth-toggle off &
        NOTIFY=off touchpad-toggle off &
        NOTIFY=off touchscreen-toggle off &

        # create autostarted status file
        touch ${autostarted-status}
      fi
    '';
  };
}
