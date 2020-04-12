{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  font = (import ./settings.nix).font;
  color = (import ./settings.nix).color;
  spacing = (import ./settings.nix).spacing;
in

{
  environment.systemPackages = with pkgs; [
    rofi
  ];

  home-manager.users."${username}" = {
    xdg.configFile = {
      "rofi/config".text = ''
        rofi.font: ${font.mono} ${toString font.size}
        rofi.scrollbar-width: 0
        rofi.bw: ${toString spacing.border}
        rofi.padding: ${toString spacing.padding}
        rofi.color-enabled: true
        ! State:           'bg',           'fg',           'bgalt',        'hlbg',        'hlfg'
        rofi.color-window: ${color.black}, ${color.white}, ${color.black}
        rofi.color-normal: ${color.black}, ${color.white}, ${color.black}, ${color.blue}, ${color.black}
        rofi.color-active: ${color.black}, ${color.yellow},${color.black}, ${color.yellow},${color.black}
        rofi.color-urgent: ${color.black}, ${color.red},   ${color.black}, ${color.red},  ${color.black}
      '';
    };
  };
}
