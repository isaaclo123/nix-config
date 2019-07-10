{ pkgs, ... }:

let polybar-config = (pkgs.writeText "polybar.conf" ''
  ;==========================================================
  ;
  ;      Polybar setup by Isaac Lo
  ;
  ;==========================================================

  [colors]
  base00 = #202746
  base01 = #293256
  base02 = #5e6687
  base03 = #6b7394
  base04 = #898ea4
  base05 = #979db4
  base06 = #dfe2f1
  base07 = #f5f7ff
  base08 = #c94922
  base09 = #c76b29
  base0A = #c08b30
  base0B = #ac9739
  base0C = #22a2c9
  base0D = #3d8fd1
  base0E = #6679cc
  base0F = #9c637a

  background = #00xFFF
  foreground = ''${colors.base07}
  foreground-alt = ''${colors.base0E}
  alert = ''${colors.base09}

  [bar/default]
  ; monitor = ''${env:MONITOR:eDP1}
  width = 100%
  height = 22
  ;offset-x = 1%
  ;offset-y = 1%
  radius = 0
  fixed-center = true

  ; override-redirect = true
  wm-restack = bspwm

  background = ''${colors.background}
  foreground = ''${colors.foreground}

  border-top-size = 14
  border-bottom-size = -6

  padding-left = 3
  padding-right = 3

  module-margin-left = 1
  module-margin-right = 1
  module-padding-right = 2

  font-0 = Gohu Font:pixelsize=14px:antialiasing=false;0
  font-1 = FontAwesome:style=Regular:pixelsize=9px;0
  ; font-2 = Weather Icons:pixelsize=9px;1
  ; font-3 = Unifont:pixelsize=14px;antialiasing=false;2

  modules-left = mpd
  modules-center = bspwm
  ;modules-right = pulseaudio openweathermap-simple mail isrunning-bluetooth vpn network-status battery time
  modules-right = pulseaudio wlan eth battery date time

  tray-position =

  cursor-click = pointer
  cursor-scroll = ns-resize

  [module/i3]
  type = internal/i3
  format = <label-state><label-mode>
  index-sort = true
  wrapping-scroll = false

  ; Only show workspaces on the same output as the bar
  ;pin-workspaces = true

  label-mode = "%mode%"
  label-mode-padding = 2
  label-mode-foreground = ''${colors.foreground}
  label-mode-background = ''${colors.background}

  ; focused = Active workspace on focused monitor
  label-focused = %index%
  label-focused-background = ''${colors.background}
  label-focused-foreground = ''${colors.foreground}
  label-focused-padding = 2

  ; unfocused = Inactive workspace on any monitor
  label-unfocused = %index%
  label-unfocused-foreground = ''${colors.base0E}
  label-unfocused-padding = 2

  ; visible = Active workspace on unfocused monitor
  label-visible = %index%
  label-visible-background = ''${colors.background}
  label-visible-padding = 2

  ; urgent = Workspace with urgency hint set
  label-urgent = %index%
  label-urgent-foreground = ''${colors.alert}
  label-urgent-padding = 2

  [module/bspwm]
  type = internal/bspwm

  label-focused = 
  ; label-focused-background = ''${colors.primary}
  ; label-focused-underline= ''${colors.primary}
  label-focused-padding = 1

  label-occupied = 
  label-occupied-padding = 1

  label-urgent = 
  ; label-urgent-background = ''${colors.alert}
  label-urgent-foreground = ''${colors.alert}
  label-urgent-padding = 1

  label-empty = 
  ; label-empty-background = ''${colors.foreground}
  ; label-empty-foreground = ''${colors.background}
  label-empty-padding = 1

  ; Separator in between workspaces
  ; label-separator = |


  [module/mpd]
  type = internal/mpd
  ; format-online = %{F#6679cc}<toggle>%{F-} <label-song>
  format-online = %{F#6679cc}%{F-}  <label-song>  %{F#6679cc}<icon-prev>  <toggle>  <icon-next>%{F-}
  format-stopped = %{F#6679cc}  MPD Stopped%{F-}
  format-offline = %{F#6679cc}  MPD Offline%{F-}

  label-font = 4
  ; label-song-maxlen = 40
  label-song-ellipsis = false
  label-song = %artist:0:20:…% - %title:0:30:…%

  ; Only applies if <icon-X> is used
  icon-prev = 
  icon-play = 
  icon-pause = 
  icon-next = 
  icon-stop = 
  icon-seekb = 
  icon-seekf = 
  icon-random = 
  icon-consume = 
  icon-repeat = 
  icon-repeatone = 

  [module/wlan]
  type = internal/network
  interface = wlp61s0
  interval = 5.0

  format-connected = <label-connected>
  format-connected-prefix = " "
  format-connected-prefix-foreground = ''${colors.foreground-alt}
  label-connected = %essid%

  format-disconnected =

  [module/eth]
  type = internal/network
  interface = enp0s31f6
  interval = 5.0

  label-connected = %local_ip%
  format-connected-prefix = " "
  format-connected-prefix-foreground = ''${colors.foreground-alt}

  format-disconnected =

  [module/date]
  type = internal/date
  interval = 5.0

  date = %Y-%m-%d

  format-prefix = " "
  format-prefix-foreground = ''${colors.foreground-alt}

  label = %date%

  [module/time]
  type = internal/date
  interval = 5.0

  date = %y-%m-%d%

  time = %H:%M

  format-prefix = " "
  format-prefix-foreground = ''${colors.foreground-alt}

  label = %time%

  [module/pulseaudio]
  type = internal/pulseaudio

  format-volume = <ramp-volume> <label-volume>%
  label-volume = %percentage%
  label-volume-foreground = ''${colors.foreground}

  format-muted = <label-muted>
  format-muted-foreground = ''${colors.foreground-alt}
  label-muted =  MUT

  ramp-volume-0 = 
  ramp-volume-1 = 
  ramp-volume-foreground = ''${colors.foreground-alt}

  [module/battery]
  type = internal/battery
  battery = BAT0
  adapter = AC
  full-at = 98

  format-charging = <label-charging>
  format-discharging = <ramp-capacity> <label-discharging>

  format-full-prefix = " "
  format-full-prefix-foreground = ''${colors.foreground-alt}

  ramp-capacity-0 = 
  ramp-capacity-1 = 
  ramp-capacity-2 = 
  ramp-capacity-foreground = ''${colors.foreground-alt}

  format-charging-prefix = " "
  format-charging-prefix-foreground = ''${colors.foreground-alt}

  [module/mail]
  type = custom/script

  format-prefix = " "
  format-prefix-foreground = ''${colors.foreground-alt}

  ; Available tokens:
  ;   %counter%
  ; Command to be executed (using "/usr/bin/env sh -c [command]")
  exec = ~/bin/mail-count
  exec-if = expr $(~/bin/mail-count) \> 0

  ; Will the script output continous content?
  ; Default: false
  tail = false

  ; Seconds to sleep between updates
  ; Default: 5 (0 if `tail = true`)
  interval = 10

  [module/openweathermap-simple]
  type = custom/script
  exec = ~/bin/openweathermap-simple.sh
  interval = 600

  label-font = 3
  label-font-foregound = ''${colors.foreground-alt}

  [module/vpn]
  type = custom/script
  exec = ~/bin/vpn-openvpn-isrunning.sh
  exec-if = ~/bin/vpn-openvpn-isrunning.sh
  interval = 5
  format-prefix = " "
  format-prefix-foreground = ''${colors.foreground-alt}

  [module/network-status]
  type = custom/script
  exec = ~/bin/network-status.sh
  exec-if = ~/bin/network-status.sh
  interval = 5
  label-font-foreground = ''${colors.foreground-alt}

  [module/isrunning-bluetooth]
  type = custom/script
  exec = ~/bin/isrunning-bluetooth.sh
  interval = 5

  format-prefix = " "
  format-prefix-foreground = ''${colors.foreground-alt}
''); in

# let polybar-ext = pkgs.polybar.override {
#   alsaSupport = true;
#   githubSupport = false;
#   pulseSupport = true;
#   mpdSupport = true;
#   iwSupport = true;
#   nlSupport = true;
#   i3Support = false;
# }; in

{
  services.polybar = {
    package = pkgs.polybar.override {
      # alsaSupport = true;
      # githubSupport = false;
      pulseSupport = true;
      mpdSupport = true;
      # iwSupport = true;
      # nlSupport = true;
      i3Support = false;
    };
    enable = true;
    config = "${polybar-config}";
    script = ''
      #!/usr/bin/env sh
      systemctl --user daemon-reload
      polybar default &
      # for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      #   MONITOR=$m polybar default &
      # done
    '';
  };
}
