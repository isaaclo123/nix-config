{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  font = (import ./settings.nix).font;
  color = (import ./settings.nix).color;
  spacing = (import ./settings.nix).spacing;
  rofi = (import ./settings.nix).rofi;
  icon = (import ./settings.nix).icon;
in

let
  rofi-themes = (pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "bcddd3d9134ffd3b0493feea448bb1451af7ff44";
    sha256 = "1z5l4l084mhj9x5av8wh6zcsq7j1i41pylmsiacn262kkq5y0wxq";
  });

  rofi-colorscheme = (pkgs.writeText "colorscheme.rasi" ''
    @import "${rofi-themes}/themes/colorschemes/${rofi.colorscheme}.rasi"
  '');
  # * {
  #   accent:           #${color.blue};
  #   background:       #${color.bg};
  #   background-light: #${color.darkgray};
  #   foreground:       #${color.fg};
  #   on:               #${color.green};
  #   off:              #${color.red};
  # }
in

{
  # Enable the clipmenu daemon
  services.clipmenu.enable = true;

  environment.systemPackages =
    let
      clipmenu-ext = (pkgs.writeShellScriptBin "clipmenu-ext" ''
        CM_HISTLENGTH=20 CM_LAUNCHER=rofi clipmenu -p Clipboard ${rofi.args}
      '');

      clipmenu-del = (pkgs.writeShellScriptBin "clipmenu-del" ''
        clipdel -d ".*" && notify-send "Clipboard Cleared"
      '');
    in
      with pkgs; [
      (clipmenu-ext)
      (clipmenu-del)

      (unstable.rofi.override {
        plugins = with pkgs; [
          icon.pkg
          unstable.rofi-emoji
        ];
      })
    ];

  home-manager.users."${username}" = {
    xdg.configFile = {
      "rofi/bin".source = "${rofi-themes}/bin";

      "rofi/config.rasi".text = ''
        configuration {
          show-icons:         true;
          icon-theme:         "Numix";
          location: 0;
          yoffset: 0;
          xoffset: 0;
        }
      '';

      # powermenu
      "rofi/scripts/menu_powermenu.sh".source = (pkgs.writeShellScript "menu_powermenu.sh" ''
        rofi_command="rofi -theme themes/menu/powermenu.rasi"
        uptime=$(uptime | sed s/,//g| awk '{ print $3}')

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

      # @import "${rofi-themes}/themes/colorschemes/${rofi.colorscheme}.rasi"
      "rofi/themes/colors.rasi".text = ''
        @import "${rofi-colorscheme}"
      '';
      "rofi/themes/menu/powermenu.rasi".text = ''
        ${builtins.readFile "${rofi-themes}/themes/menu/powermenu.rasi"}

        #window {
          width: 761px;
          height: 260px;
        }

        * {
          /* General */
          text-font:                            "${font.mono} 14"; /* sans maybe */
        }
      '';

      # launcher
      "rofi/launchers/launcher.sh".source = (pkgs.writeShellScript "launcher.sh" ''
        rofi -no-lazy-grab -show combi -combi-modi "drun,run" -modi combi -display-combi Applications -display-run Run -display-drun App -theme launchers/${rofi.style}.rasi
      '');

      "rofi/colors.rasi".text = ''
        @import "${rofi-colorscheme}"
      '';
      "rofi/launchers/${rofi.style}.rasi".source = "${rofi-themes}/launchers/${rofi.style}.rasi";
    };
  };
}
