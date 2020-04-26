{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  font = (import ./settings.nix).font;
  color = (import ./settings.nix).color;
  spacing = (import ./settings.nix).spacing;
in

let
  rofi-themes = (pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "bcddd3d9134ffd3b0493feea448bb1451af7ff44";
    sha256 = "1z5l4l084mhj9x5av8wh6zcsq7j1i41pylmsiacn262kkq5y0wxq";
  });

  colors-rasi = ''
    @import "colorschemes/gruvbox.rasi"
  '';
in

{
  environment.systemPackages =
    let clipmenu-ext = (pkgs.writeShellScriptBin "clipmenu-ext" ''
      CM_HISTLENGTH=20 CM_LAUNCHER=rofi clipmenu -p  -theme-str '#textbox-prompt-colon { str: ""; }'
    ''); in

    let clipmenu-del = (pkgs.writeShellScriptBin "clipmenu-del" ''
      clipdel -d ".*" && notify-send "Clipboard Cleared"
    ''); in

    with pkgs; [
      (clipmenu-ext)
      (clipmenu-del)
      (unstable.rofi.override {
        plugins = with pkgs; [
          numix-icon-theme
        ];
    })

    (pkgs.writeShellScriptBin "rofi-wrapper" ''
      # ${pkgs.rofi}/bin/rofi -theme-str '#textbox-prompt-colon { str: ""; }' "$@"
      ${pkgs.rofi}/bin/rofi "$@"
    '')
  ];

  # Enable the clipmenu daemon
  services.clipmenu.enable = true;

  home-manager.users."${username}" = {
    xdg.configFile = {
      "rofi/bin".source = "${rofi-themes}/bin";
      # "rofi/scripts".source = "${rofi-themes}/scripts";

      # powermenu and themes
      "rofi/themes/colorschemes".source = "${rofi-themes}/themes/colorschemes";

      "rofi/scripts/menu_powermenu.sh".source = (pkgs.writeShellScript "menu_powermenu.sh" ''
        rofi_command="rofi -theme themes/menu/powermenu.rasi"
        uptime=$(uptime | sed 's/.*up \([^,]*\), .*/\1/')
        #mem=$( free -h | grep -i mem | awk -F ' ' '{print $3}')
        cpu=$(sh ~/.config/rofi/bin/usedcpu)
        memory=$(sh ~/.config/rofi/bin/usedram)

        # Options
        shutdown="襤"
        reboot="ﰇ"
        lock=""
        suspend="鈴"
        logout=""

        # Variable passed to rofi
        options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

        chosen="$(echo -e "$options" | $rofi_command -p "祥  $uptime    $cpu    $memory " -dmenu -selected-row 2)"
        case $chosen in
            $shutdown)
                systemctl poweroff
                ;;
            $reboot)
                systemctl reboot
                ;;
            $lock)
                lock -l
                ;;
            $suspend)
                lock -s
                ;;
            $logout)
                logout-desktop
                ;;
        esac
      '');

      "rofi/themes/menu/powermenu.rasi".text =
        (builtins.readFile "${rofi-themes}/themes/menu/powermenu.rasi") + ''

        #window {
          width: 761px;
          height: 260px;
        }

        * {
          /* General */
          text-font:                            "${font.mono} 14"; /* sans maybe */
        }
      '';

      "rofi/themes/colors.rasi".text = ''
        @import "colorschemes/gruvbox.rasi"
      '';

      # launcher
      "rofi/launchers/launcher.sh".source = (pkgs.writeShellScript "launcher.sh" ''
        style="style_normal_grid"
        rofi -no-lazy-grab -show combi -combi-modi "drun,run" -modi combi -display-combi Applications -display-run Run -display-drun App -show-icons -theme launchers/"$style".rasi
      '');
      "rofi/launchers/colors.rasi".text = ''
        @import "../themes/colorschemes/gruvbox.rasi"
      '';
      "rofi/launchers/style_normal_grid.rasi".source = "${rofi-themes}/launchers/style_normal_grid.rasi";

      # config

      "rofi/config.rasi".text = ''
        configuration {
          icon-theme:         "Numix";
          show-icons:         true;
          location: 0;
          yoffset: 0;
          xoffset: 0;
        }
        '';
    };

    programs.rofi = {
      enable = false;

      # package =
      font = "${font.mono} ${toString font.size}";
      scrollbar = false;
      padding = spacing.padding;
      borderWidth = spacing.border;
      terminal = "${pkgs.termite}/bin/termite";

      colors = {
        rows = {
          normal = {
            background = "#${color.black}";
            foreground = "#${color.white}";
            backgroundAlt = "#${color.black}";

            highlight = {
              background = "#${color.blue}";
              foreground = "#${color.black}";
            };
          };

          active = {
            background = "#${color.black}";
            foreground = "#${color.yellow}";
            backgroundAlt = "#${color.black}";

            highlight = {
              background = "#${color.yellow}";
              foreground = "#${color.black}";
            };
          };

          urgent = {
            background = "#${color.black}";
            foreground = "#${color.red}";
            backgroundAlt = "#${color.black}";

            highlight = {
              background = "#${color.red}";
              foreground = "#${color.black}";
            };
          };
        };

        window = {
          separator = "#${color.black}";
          background = "#${color.black}";
          border = "#${color.white}";
        };
      };

      extraConfig = ''
        theme-str: '#textbox-prompt-colon { str: ""; }'
        rofi.display-run: 
        rofi.display-window: 类
        rofi.display-ssh: ﯱ
        rofi.display-drun: 
        rofi.display-combi: 
        rofi.display-keys: 
      '';
    };
  };
}
