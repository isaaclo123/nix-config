{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  font = (import ./settings.nix).font;
  spacing = (import ./settings.nix).spacing;
  opacity = (import ./settings.nix).opacity;
in

let toggle-lock = "/tmp/termite-scratchpad-toggle.lock"; in

{
  environment.systemPackages =
    let termite-open = (pkgs.writeShellScriptBin "termite-open" ''
      ${pkgs.termite}/bin/termite --class="termiteopen" -e "$*"
    ''); in

    let termite-scratchpad = (pkgs.writeShellScriptBin "termite-scratchpad" ''
      ${pkgs.termite}/bin/termite --class="termitescratchpad"
    ''); in

    let termite-scratchpad-toggle = (pkgs.writeShellScriptBin "termite-scratchpad-toggle" ''
      ID=$(xdotool search --class 'termitescratchpad' | tail -n1)
      VISIBLE_IDS=$(xdotool search --onlyvisible --classname 'termitescratchpad')

      [ -z $ID ] && exit 0

      bspc node $ID --flag hidden
      bspc node --focus $ID
    ''); in
    with pkgs; [
      (termite-open)
      (termite-scratchpad)
      (termite-scratchpad-toggle)
      unstable.termite
    ];

  home-manager.users."${username}" = {
    gtk.gtk3.extraCss = ''
      .termite {
        padding: ${toString spacing.padding}px;
      }
    '';

    xdg.configFile = {
      "termite/config".text =
        # (builtins.readFile (pkgs.fetchurl {
        #   url = "https://raw.githubusercontent.com/morhetz/gruvbox-contrib/master/termite/gruvbox-dark";
        #   sha256 = "0pza2d78jqq0cssyirgsxwb4lvgzcp6m64q57ghi3qmhqgswcyp9";
        # }))
        # hard contrast
        # background = #282828
        # soft contrast: background = #32302f
        # background = rgba(29, 32, 33, ${builtins.toString (1.0 - opacity.inactive)})
        ''
          [colors]
          # background = #1d2021
          background = rgba(29, 32, 33, ${builtins.toString (opacity.inactive)})
          foreground = #ebdbb2
          foreground_bold = #ebdbb2

          # dark0 + gray
          color0 = #1d2021
          color8 = #928374

          # neutral_red + bright_red
          color1 = #cc241d
          color9 = #fb4934

          # neutral_green + bright_green
          color2 = #98971a
          color10 = #b8bb26

          # neutral_yellow + bright_yellow
          color3 = #d79921
          color11 = #fabd2f

          # neutral_blue + bright_blue
          color4 = #458588
          color12 = #83a598

          # neutral_purple + bright_purple
          color5 = #b16286
          color13 = #d3869b

          # neutral_aqua + faded_aqua
          color6 = #689d6a
          color14 = #8ec07c

          # light4 + light1
          color7 = #a89984
          color15 = #ebdbb2

          color16 = #3c3836
          color17 = #fe8019
          color18 = #d65d0e

          # vim: ft=dosini cms=#%s

          [options]
          font = Unifont Upper ${toString font.size}
          font = Unifont ${toString font.size}
          font = Symbola ${toString font.size}
          font = Latin Modern Math ${toString font.size}
          font = ${font.mono} ${toString font.size}
          fullscreen = false
        '';
        # font = Unifont ${toString font.size}
    };
  };
}
