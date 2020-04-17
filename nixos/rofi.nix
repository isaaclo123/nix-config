{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  font = (import ./settings.nix).font;
  color = (import ./settings.nix).color;
  spacing = (import ./settings.nix).spacing;
in

{
  # environment.systemPackages = with pkgs; [
  #   rofi
  # ];

  # home-manager.users."${username}" = {
  #   xdg.configFile = {
  #     "rofi/config".text = ''
  #       rofi.terminal: termite
  #       rofi.font: ${font.mono} ${toString font.size}
  #       rofi.scrollbar-width: 0
  #       rofi.bw: ${toString spacing.border}
  #       rofi.padding: ${toString spacing.padding}
  #       rofi.color-enabled: true
  #       ! State:           'bg',           'fg',           'bgalt',        'hlbg',        'hlfg'
  #       rofi.color-window: #${color.black}, #${color.white}, #${color.black}
  #       rofi.color-normal: #${color.black}, #${color.white}, #${color.black}, #${color.blue}, #${color.black}
  #       rofi.color-active: #${color.black}, #${color.yellow},#${color.black}, #${color.yellow},#${color.black}
  #       rofi.color-urgent: #${color.black}, #${color.red},   #${color.black}, #${color.red},  #${color.black}
  #     '';
  #   };
  # };

  home-manager.users."${username}" = {
    programs.rofi = {
      enable = true;
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

      # extraConfig = ''
      #   rofi.terminal: termite
      # '';
    };
  };
}
