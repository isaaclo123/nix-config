{ config, lib, pkgs, ... }:

with lib;

let sxhkdrc = (pkgs.writeText "sxkhdrc" ''
    #
    # wm independent hotkeys
    #

    # music controls
    XF86AudioRaiseVolume
      pactl set-sink-volume @DEFAULT_SINK@ '+10%'

    XF86AudioLowerVolume
      pactl set-sink-volume @DEFAULT_SINK@ '-10%'

    XF86AudioMute
      pactl set-sink-mute @DEFAULT_SINK@ toggle

    XF86AudioMicMute
      pactl set-source-mute 1 toggle

    XF86AudioPrev
      playerctl previous

    XF86AudioNext
      playerctl next

    XF86AudioPlay
      playerctl play-pause

    XF86AudioStop
      playerctl stop

    XF86MonBrightnessUp
      brightnessctl set +10%

    XF86MonBrightnessDown
      brightnessctl set 10%-

    # terminal emulator
    super + Return
      termite

    # browser
    super + b
      qutebrowser

    # lock
    super + Delete
      i3lock-pixeled

    # program launcher
    super + d
      rofi -show run

    # rofi pass
    super + p
      rofi-pass

    # clipmenu rofi
    super + c
      CM_HISTLENGTH=15 CM_LAUNCHER=rofi clipmenu

    #
    # bspwm hotkeys
    #

    # quit/restart bspwm
    super + shift + e
        bspc quit

    super + shift + r
        reload-desktop

    # close and kill
    super + shift + q
        bspc node -c

    super + ctrl + q
        bspc node -k

    # alternate between the tiled and monocle layout
    super + m
        bspc desktop -l next

    # send the newest marked node to the newest preselected node
    super + y
        bspc node newest.marked.local -n newest.!automatic.local

    # swap the current node and the biggest node
    super + g
        bspc node -s biggest

    #
    # state/flags
    #

    # set the window state
    super + {t,s,space,f}
        bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

    # set the node flags
    # super + ctrl + {m,l,s,p}
        bspc node -g {marked,locked,sticky,private}

    #
    # focus/swap
    #

    # focus the node in the given direction
    super + {_,shift + }{h,j,k,l}
        bspc node -{f,s} {west,south,north,east}

    # focus the node for the given path jump
    super + {p,b,comma,period}
        bspc node -f @{parent,brother,first,second}

    # focus the next/previous node in the current desktop
    # super + {_,shift + }c
    #     bspc node -f {next,prev}.local

    # focus the next/previous desktop in the current monitor
    # super + bracket{left,right}
    #     bspc desktop -f {prev,next}.local

    # focus the last node/desktop
    # super + {grave,Tab}
    #     bspc {node,desktop} -f last

    # focus the older or newer node in the focus history
    super + {o,i}
        bspc wm -h off; \
        bspc node {older,newer} -f; \
        bspc wm -h on

    # focus or send to the given desktop
    super + {_,shift + }{1-9,0}
        bspc {desktop -f,node -d} '^{1-9,10}'

    #
    # preselect
    #

    # preselect the direction
    super + ctrl + {h,j,k,l}
        bspc node -p {west,south,north,east}

    # preselect the ratio
    super + ctrl + {1-9}
        bspc node -o 0.{1-9}

    # cancel the preselection for the focused node
    super + Escape
        bspc node -p cancel; bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

    #
    # move/resize
    #

    # expand a window by moving one of its side outward
    super + alt + {h,j,k,l}
        bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

    # contract a window by moving one of its side inward
    super + alt + shift + {h,j,k,l}
        bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

    # move a floating window
    super + {Left,Down,Up,Right}
        bspc node -v {-20 0,0 20,0 -20,20 0}
  ''); in
{

  config = {
    environment.systemPackages = with pkgs; [
      sxhkd
    ];

    environment.etc.sxhkdrc = {
      text = builtins.readFile sxhkdrc;
    };

    services.xserver.windowManager.bspwm.sxhkd.configFile = "/etc/sxhkdrc";
    # environment.systemPackages = with pkgs; [
    #   scrot
    # ];
  };
}
