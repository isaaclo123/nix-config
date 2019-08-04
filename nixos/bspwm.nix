{ config, pkgs, lib, ... }:

with lib;

let bspwmrc = (pkgs.writeText "bspwmrc" ''
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

  bspc rule -a termite_ desktop='^2'
  bspc rule -a vim_ desktop='^3'
  bspc rule -a ranger_ desktop='^4'
  bspc rule -a neomutt_ desktop='^5'
  bspc rule -a ncmpcpp_ desktop='^6'

  bspc rule -a mpv:mpvscratchpad sticky=on state=floating hidden=on border=off

  # autostart

  killall -q dunst && (dunst &)

  mpv-scratchpad &

  autocutsel -s PRIMARY &

  qutebrowser &
  termite --class=termite_ &
  termite --class=vim_ -e vim &
  termite --class=ranger_ -e ranger &
  termite --class=neomutt_ -e neomutt &
  termite --class=ncmpcpp_ -e ncmpcpp &

  # feh
  feh --bg-scale /etc/nixos/wallpaper.jpg
''); in

{
  config = {
    environment.systemPackages = with pkgs; [
      bspwm
    ];

    environment.etc.bspwmrc = {
      text = builtins.readFile bspwmrc;
      mode = "0645";
    };

    services.xserver.windowManager = {
      bspwm = {
        enable = true;
        configFile = "/etc/bspwmrc";
      };

      default = "bspwm";
    };
  };
}
