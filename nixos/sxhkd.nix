{ pkgs, ... }:

let
  rofi = (import ./settings.nix).rofi;
  icon = (import ./settings.nix).icon;
in

# creates input toggle scripts based on device name and script name
let input-toggle-create = device: script-name: icon: (pkgs.writeShellScriptBin script-name ''
  # toggle device

  DEVICE="${device}"

  NOTIFY_VAL=''${NOTIFY:-on}

  enable_device () {
    xinput enable "$DEVICE" &&
    [ "$NOTIFY_VAL" == "on" ] && notify-send -i "${icon}" "${device} Enabled"
  }

  disable_device () {
    xinput disable "$DEVICE" &&
    [ "$NOTIFY_VAL" == "on" ] && notify-send -i "${icon}" "${device} Disabled"
  }

  if [ "$1" == "on" ]; then
    enable_device
    exit 0
  fi
  if [ "$1" == "off" ]; then
    disable_device
    exit 0
  fi

  # Use device name and check for status

  if [[ $(xinput list "$DEVICE" | grep -Ec "disabled") -eq 1 ]]; then
    enable_device
  else
    disable_device
  fi
''); in

{

  environment.systemPackages =
    let
      touchscreen-toggle = (input-toggle-create "ELAN Touchscreen" "touchscreen-toggle" "${icon.path}/devices/display.svg");

      touchpad-toggle = (input-toggle-create "ETPS/2 Elantech Touchpad" "touchpad-toggle" "${icon.path}/devices/input-touchpad.svg");

      bluetooth-toggle = (pkgs.writeShellScriptBin "bluetooth-toggle" ''
        BT=$(rfkill list | grep tpacpi_bluetooth_sw | cut -d: -f1)

        BT_STATE=$(rfkill list $BT | grep "Soft blocked: yes")

        NOTIFY_VAL=''${NOTIFY:-on}

        enable_device () {
          sudo rfkill unblock $BT &&
          sleep 1 && sudo rfkill unblock $(rfkill list | grep hci0 | cut -d: -f1) &&
          [ "$NOTIFY_VAL" == "on" ] && ${pkgs.libnotify}/bin/notify-send -i "${icon.path}/categories/preferences-bluetooth.svg" "Bluetooth Enabled"
        }

        disable_device () {
          sudo rfkill block $BT &&
          [ "$NOTIFY_VAL" == "on" ] && ${pkgs.libnotify}/bin/notify-send -i "${icon.path}/categories/preferences-bluetooth.svg" "Bluetooth Disabled"
        }

        if [ "$1" == "on" ]; then
          enable_device
          exit 0
        fi
        if [ "$1" == "off" ]; then
          disable_device
          exit 0
        fi

        if [ -z "$BT_STATE" ]; then
          # if is not soft blocked
          disable_device
        else
          enable_device
        fi
      '');

      screenshot = (pkgs.writeShellScriptBin "screenshot" ''
        SCREENSHOT=~/Pictures/Screenshots/Screenshot_%Y%m%d-%H%M%S.png
        scrot "$@" $SCREENSHOT -e '${pkgs.libnotify}/bin/notify-send -i "${icon.path}/categories/applications-photography.svg" "Screenshot Saved" "$f"'
      '');
    in

    with pkgs; [
      (touchscreen-toggle)
      (touchpad-toggle)
      (bluetooth-toggle)
      (screenshot)
      sxhkd
    ];

  services.xserver.windowManager.bspwm.sxhkd.configFile = "/etc/sxhkdrc";

  environment.etc.sxhkdrc = {
    mode = "0644";
    text = ''
      #
      # wm independent hotkeys
      #

      # volume controls
      {XF86AudioMute, super + F1}
        pactl set-sink-mute @DEFAULT_SINK@ toggle

      {XF86AudioLowerVolume, super + F2}
        pactl set-sink-volume @DEFAULT_SINK@ '-5%'

      {XF86AudioRaiseVolume, super + F3}
        pactl set-sink-volume @DEFAULT_SINK@ '+5%'

      {XF86AudioMicMute, super + F4}
        pactl set-source-mute 1 toggle

      {XF86MonBrightnessDown, super + F5}
        brightnessctl set 5%-

      {XF86MonBrightnessUp, super + F6}
        brightnessctl set +5%

      # Toggle touchscreen
      {XF86Display, super + F7}
        touchscreen-toggle

      # Toggle touchpad
      {XF86Tools, super + F9}
        touchpad-toggle

      # Toggle bluetooth
      {XF86Bluetooth, super + F10}
        bluetooth-toggle

      # lock
      super + F11
        lock -l

      {XF86Favorites, super + F12}
        sleep 0.5 && xset dpms force off

      # media controls
      super + Home
        mpc prev

      super + End
        mpc toggle

      super + Insert
        mpc next

      # media control special buttons

      XF86AudioPrev
        mpv-scratchpad-ctl previous
      # mpc prev

      XF86AudioNext
        mpv-scratchpad-ctl next
      # mpc next

      XF86AudioPlay
        mpv-scratchpad-ctl play
      # mpc play

      XF86AudioPause
        mpv-scratchpad-ctl pause
      # mpc pause

      super + Print
        screenshot

      @super + @shift + @Print
        screenshot -s

      # lock and suspend
      super + Delete
        lock -s

      # terminal emulator
      super + Return
        termite

      # browser
      super + b
        qutebrowser

      # program launcher
      super + d
        ~/.config/rofi/launchers/launcher.sh

      # rofi pass
      super + p
        rofi-pass

      # clipmenu rofi
      super + {_,shift + }c
          {clipmenu-ext,clipmenu-del}

      # rofimoji
      super + e
      	rofimoji --rofi-args="${rofi.args}"

      # mpv toggle
      super + Up
        mpv-scratchpad-toggle

      # seek forward
      super + Right
        mpv-scratchpad-ctl forward 3

      # seek back
      super + Left
        mpv-scratchpad-ctl backward 3

      # mpv play/pause
      super + Down
        mpv-scratchpad-ctl play-pause

      # mpv fullscreen toggle
      super + shift + Up
        mpv-scratchpad-fullscreen-toggle

      # next track
      super + shift + Right
          mpv-scratchpad-ctl next

      # prev track
      super + shift + Left
          mpv-scratchpad-ctl previous

      # mpv scratchpad hide
      super + shift + Down
        mpv-scratchpad-hide

      # shorter seek
      super + Prior
        mpv-scratchpad-ctl forward 1

      super + Next
        mpv-scratchpad-ctl backward 1

      # restart
      super + shift + Prior
        mpv-scratchpad-ctl restart

      # end
      super + shift + Next
        mpv-scratchpad-ctl end

      # termite scratchpad
      super + grave
        termite-scratchpad-toggle

      #
      # bspwm hotkeys
      #

      # quit/restart bspwm
      super + ctrl + e
          ~/.config/rofi/scripts/menu_powermenu.sh

      super + ctrl + r
          reload-desktop

      # window rotate and flip

      # Rotate desktop
      super + {_,shift + }r
          bspc node @/ --rotate {90,-90}

      # Circulate the leaves of the tree
      super + {_,shift + }x
          bspc node @/ --circulate {backward,forward}

      # flip
      super + v
          bspc node @/ --flip vertical

      super + u
          bspc node @/ --flip horizontal

      # Make split ratios equal
      super + equal
      	bspc node @/ --equalize

      # Make split ratios balanced
      super + minus
      	bspc node @/ --balance

      # close and kill
      super + shift + q
          bspc node -c

      super + ctrl + q
          bspc node -k

      # alternate between the tiled and monocle layout
      super + m
          bspc desktop -l next

      # send the newest marked node to the newest preselected node
      # super + y
      #     bspc node newest.marked.local -n newest.!automatic.local

      # swap the current node and the biggest node
      # super + g
      #     bspc node -s biggest

      #
      # state/flags
      #

      # set the window state
      super + {t,shift + t,s,f}
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

      # Navigate layouts
      super + {_,shift + }space
          bspc node -f {next,prev}.local

      # focus the node for the given path jump
      # super + {p,b,comma,period}
      #     bspc node -f @{parent,brother,first,second}

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
      # super + {o,i}
      #     bspc wm -h off; \
      #     bspc node {older,newer} -f; \
      #     bspc wm -h on

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
      #super + {Left,Down,Up,Right}
      #      bspc node -v {-20 0,0 20,0 -20,20 0}
    '';
  };
}
