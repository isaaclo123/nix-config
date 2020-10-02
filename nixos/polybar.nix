{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  color = (import ./settings.nix).color;
  font = (import ./settings.nix).font;
  spacing = (import ./settings.nix).spacing;
  opacity = (import ./settings.nix).opacity;

  theme-name = "polybar-8";
  theme-icon = "material";
in

let
  polybar-themes = (pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "polybar-themes";
    rev = "786166cf976d4a64f90bb108fb76bb4eb33555f3";
    sha256 = "0db7j02g133zlhy3ccvny9gkvzciwi4fi5dkisclnzy1pzhxdg6g";
  });

  themes-folder = "${polybar-themes}/${theme-name}/source/${theme-icon}";
in

{
  home-manager.users."${username}" = {
      xdg.configFile = {
        "polybar/scripts".source = "${themes-folder}/scripts";
      };

      services.polybar = {
        enable = true;

        package = pkgs.polybar.override {
          # alsaSupport = true;
          # githubSupport = false;
          # iwSupport = true;
          # nlSupport = true;
          pulseSupport = true;
          mpdSupport = true;
          i3Support = false;
        };

        script = ''
          #!/usr/bin/env sh
          systemctl --user daemon-reload
          polybar main &
        '';

        config =
          let
            icon-fg = color.black;
            icon-bg = color.white;
            fg = color.white;
            bg = color.darkgray;

            bar-background = "${opacity.inactive-hex}${color.black}";

            bar-color = {
              bg = "#${fg}";
              fg = "#${fg}";
              fg-alt = "#${bg}";
              mf = "#${bg}";

              # bg = "#${color.bg}";
              # fg = "#${color.bg}";
              # fg-alt = "#${color.fg}";
              # mf = "#${color.fg}";
              ac = "#${color.green}";

              # bars
              bn = "#${color.green}";
              bm = "#${color.yellow}";
              bd = "#${color.red}";

              trans = "#00000000";
              white = "#FFFFFF";
              black = "#000000";

              red = "#${color.red}";
              purple = "#${color.purple}";
              blue = "#${color.blue}";
              cyan = "#${color.cyan}";
              green = "#${color.green}";
              yellow = "#${color.yellow}";
              orange = "#${color.orange}";
              grey = "#${color.gray}";

              # temp
              pink = "#${color.red}";
              teal = "#${color.cyan}";
              lime = "#${color.green}";
              amber = "#${color.yellow}";
              brown = "#${color.green}";
              indigo = "#${color.purple}";
              blue-gray = "#${color.alt.gray}";
            };
          in {
            "color" = bar-color;

            "global/wm" = {
              margin-bottom = 0;
              margin-top = 0;

              # include-file = "${themes-folder}/colors.ini";
              include-file = "${themes-folder}/modules.ini\ninclude-file=${themes-folder}/user_modules.ini\ninclude-file=${themes-folder}/bars.ini";
            };

            "module/sep" = {
              type = "custom/text";
              content = "|";

              content-background = "#${bar-background}";
              content-foregorund = "#${bar-background}";
              content-padding = "0.5";
            };

            "bar/main" = {
              wm-restack = "bspwm";
              monitor-fallback = "";
              monitor-strict = false;
              override-redirect = false;
              bottom = false;
              fixed-center = true;

              width = "100%";
              height = 22;
              offset-x = 0;
              offset-y = 0;

              background = "#${bar-background}"; # 90 percent opacity
              foreground = "#${color.fg}";

              radius-top = "0.0";
              radius-bottom = "0.0";

              overline-size = 2;
              overline-color = bar-color.ac;

              border-size = 4; # Used to be border-size
              border-color = "#${bar-background}";

              padding = 1;
              module-margin-left = 0;
              module-margin-right = 0;

              font-0 = "${font.mono}:size=${toString font.size};2";
              font-1 = "${font.mono}:size=${toString font.size};2";
              # font-1 = "Material Icons:size=${toString (font.size + 2)};2";
              # font-2 = "xos4 Terminus:size=${toString (font.size + 2)};2";

              # Available modules
              #
              # alsa backlight battery
              # bspwm cpu date
              # filesystem github i3
              # memory mpd wired-network
              # network pulseaudio temperature
              # keyboard title workspaces

              modules-left = "bspwm sep my_mpd_bar_i my_mpd_bar sep";
              modules-center = "my_title";
              modules-right = "jblock_on_i jblock_off_i jblock sep my_pulseaudio_i my_pulseaudio sep my_network_i my_network sep my_battery_i my_battery sep my_date_day_i my_date_day sep my_date_i my_date";
              #  separator network_i network separator date_i date

              # Opacity value between 0.0 and 1.0 used on fade in/out
              dim-value = "1.0";

              # Locale used to localize various module data (e.g. date)
              # Expects a valid libc locale, for example: sv_SE.UTF-8
              # locale =

              tray-position = "none";
              tray-detached = false;
              tray-maxsize = 16;
              tray-background = "#${color.bg}";
              tray-offset-x = 0;
              tray-offset-y = 0;
              tray-padding = 0;
              tray-scale = "1.0";
              enable-ipc = true;

              # cursor-click =
              # cursor-scroll =

              # scroll-up = "bspwm-deskprev";
              # scroll-down = "bspwm-desknext";
            };

            "settings" = {
              throttle-output = 5;
              throttle-output-for = 10;
              throttle-input-for = 30;
              screenchange-reload = false;
              compositing-background = "source";
              compositing-foreground = "over";
              compositing-overline = "over";
              compositing-underline = "over";
              compositing-border = "over";

              pseudo-transparency = true;

              format-foreground = "#${color.black}";
              format-background = "#${color.alt.bg}";
              format-underline = "#${color.alt.bg}";
            };

            "module/bspwm" = {
              type = "internal/bspwm";

              pin-workspaces = true;
              strip-wsnumbers = true;
              index-sort = true;

              enable-click = true;
              enable-scroll = false;

              wrapping-scroll = false;
              reverse-scroll = false;

              ws-icon-0 = "1;";
              ws-icon-1 = "2;";
              ws-icon-2 = "3;";
              ws-icon-3 = "4;";
              ws-icon-4 = "5;";
              ws-icon-5 = "6;ﱘ";
              ws-icon-6 = "7;";
              ws-icon-7 = "8;8";
              ws-icon-8 = "9;9";
              ws-icon-9 = "0;10";

              fuzzy-match = false;

              format = "<label-state> <label-mode>";
              label-focused = "%icon%";
              label-focused-foreground = "#${color.black}";
              label-focused-background = bar-color.ac;
              label-focused-underline = bar-color.ac;
              label-focused-padding = 1;

              label-occupied = "%icon%";
              label-occupied-foreground = "#${fg}";
              label-occupied-background = "#${bg}";
              label-occupied-underline = "#${bg}";
              label-occupied-padding = 1;

              label-empty = "";

              label-mode = "%mode%";
              label-mode-padding = 2;
              label-mode-foreground = "#${color.black}";
              label-mode-background = bar-color.ac;

              label-urgent = "%icon%";
              label-urgent-foreground = "#${color.black}";
              label-urgent-background = "#${color.red}";
              label-urgent-padding = 1;
            };

            "module/my_title" = {
              "inherit" = "module/title";
              format-background = "#${color.black}";
              format-foreground = "#${color.white}";

              label = " %title%";
              label-maxlen = 35;
            };

            "module/my_mpd_bar" = {
              "inherit "= "module/mpd_bar";

              format-online = "<label-song> <icon-next>";
              format-online-background = "#${bg}";
              format-online-foreground = "#${fg}";
              format-online-padding = 1;

              label-song =  "%artist% - %title%";
              label-song-maxlen = 25;
              label-song-ellipsis = true;

              label-offline = "MPD is offline";

              icon-play = "契";
              icon-pause = "";
              icon-stop = "栗";
              icon-prev = "玲";
              icon-next = "怜";
            };

            "module/my_mpd_bar_i" = {
              "inherit" = "module/mpd_bar_i";

              format-online-background = "#${color.red}";
              format-online-foreground = "#${color.black}";
              icon-play = "契";
              icon-pause = "";
            };

            "module/my_pulseaudio" = {
              "inherit" = "module/pulseaudio";
            };

            "module/my_pulseaudio_i" = {
              type = "internal/pulseaudio";

              format-volume = "<ramp-volume>";
              format-muted-background = "#${color.blue}";
              format-volume-background = "#${color.blue}";
              format-volume-padding = 1;

              label-muted = "ﱝ";
              format-muted-padding = 1;
              # label-muted-foreground = "#${color.black}";

              ramp-volume-0 = "奄";
              ramp-volume-1 = "奔";
              ramp-volume-2 = "墳";
            };

            "module/my_network" = {
              "inherit" = "module/network";
              interface = "wlp61s0";
            };

            "module/my_network_i" = {
              "inherit" = "module/network_i";
              interface = "wlp61s0";

              format-connected-foreground = "#${icon-fg}";
              format-disconnected-foreground = "#${icon-fg}";

              label-disconnected = "睊";
              ramp-signal-0 = "直";
              ramp-signal-1 = "直";
              ramp-signal-2 = "直";
              ramp-signal-3 = "直";
              ramp-signal-4 = "直";
            };

            "module/my_battery" = {
              "inherit" = "module/battery";

              full-at = 98;
              battery = "BAT0";
              adapter = "AC";

              label-full-foreground = "#${color.black}";
              label-full-background = "#${color.white}";
            };

            "module/my_battery_i" = {
              type = "internal/battery";

              full-at = 98;
              battery = "BAT0";
              adapter = "AC";

              poll-interval = 2;
              time-format = "%H:%M";

              format-charging = "<animation-charging>";
              format-charging-background = "#${color.green}";
              format-charging-foreground = "#${color.black}";
              format-charging-padding = 1;

              format-discharging = "<ramp-capacity>";
              format-discharging-background = "#${color.red}";
              format-discharging-foreground = "#${color.black}";
              format-discharging-padding = 1;

              label-charging = "%percentage%%";
              label-discharging = "%percentage%%";

              label-full = "";
              label-full-background = "#${color.green}";
              label-full-foreground = "#${color.black}";
              label-full-padding = 1;

              ramp-capacity-0 = "";
              ramp-capacity-1 = "";
              ramp-capacity-2 = "";
              ramp-capacity-3 = "";
              ramp-capacity-4 = "";
              ramp-capacity-5 = "";
              ramp-capacity-6 = "";
              ramp-capacity-7 = "";
              ramp-capacity-8 = "";
              ramp-capacity-9 = "";

              animation-charging-0 = "";
              animation-charging-1 = "";
              animation-charging-2 = "";
              animation-charging-3 = "";
              animation-charging-4 = "";
              animation-charging-5 = "";
              animation-charging-6 = "";

              animation-charging-framerate = 750;
            };

            "module/my_date_day" = {
              "inherit" = "module/date";

              time = "%a, %b %d";
              # time-alt = "%Y-%m-%d%";
              time-alt = "";
            };

            "module/my_date_day_i" = {
              "inherit" = "module/date_i";

              format-foreground = "#${icon-fg}";

              time = "";
            };

            "module/my_date" = {
              "inherit" = "module/date";

              time = "%H:%M";
              # time-alt = "%Y-%m-%d%";
              time-alt = "";
            };

            "module/my_date_i" = {
              "inherit" = "module/date_i";

              format-foreground = "#${icon-fg}";
              format-background = "#${color.orange}";

              time = "";
              # time-alt = "";
              time-alt = "";
            };

            "module/jblock_on_i" = {
              type = "custom/script";
              format-foreground = "#${icon-fg}";
              format-background = "#${color.red}";
              format-padding = 1;
              exec = "echo ";
              exec-if = "test ! -f /tmp/jmatrix-off.tmp";
              interval = 2;
            };

            "module/jblock_off_i" = {
              type = "custom/script";
              format-foreground = "#${icon-fg}";
              format-background = "#${color.green}";
              format-padding = 1;
              exec = "echo ";
              exec-if = "test -f /tmp/jmatrix-off.tmp";
              interval = 2;
            };

            "module/jblock" = {
              type = "custom/script";
              format-foreground = "#${color.fg}";
              format-background = "#${bg}";
              format-padding = 1;
              exec = "test -f /tmp/jmatrix-off.tmp && echo 'Off' || echo 'On'";
              interval = 2;
              # type = "custom/text";
              # content-foreground = "#${color.fg}";
              # content-background = "#${bg}";
              # content-padding = 1;
              # content = "JMatrix";
              # exec = "test -f /tmp/jmatrix-off.tmp && echo 'JMatrix OFF' || echo 'JMatrix ON'";
            };
          };
      };
    };
}
