{ pkgs, ... }:

let termite-config = (pkgs.writeText "config" ''
  [colors]
  # Base16 Atelier Sulphurpool
  # Author: Bram de Haan (http://atelierbramdehaan.nl)

  foreground          = #979db4
  foreground_bold     = #dfe2f1
  cursor              = #dfe2f1
  cursor_foreground   = #202746
  background          = #202746

  # 16 color space

  # Black, Gray, Silver, White
  color0  = #202746
  color8  = #6b7394
  color7  = #979db4
  color15 = #f5f7ff

  # Red
  color1  = #c94922
  color9  = #c94922

  # Green
  color2  = #ac9739
  color10 = #ac9739

  # Yellow
  color3  = #c08b30
  color11 = #c08b30

  # Blue
  color4  = #3d8fd1
  color12 = #3d8fd1

  # Purple
  color5  = #6679cc
  color13 = #6679cc

  # Teal
  color6  = #22a2c9
  color14 = #22a2c9

  # Extra colors
  color16 = #c76b29
  color17 = #9c637a
  color18 = #293256
  color19 = #5e6687
  color20 = #898ea4
  color21 = #dfe2f1

  [options]
  font = Unifont Upper 14px
  font = Unifont 14px
  font = Siji 9px
  font = FontAwesome 9px
  font = GohuFont 14px
''); in

let termite-open = (pkgs.writeShellScriptBin "termite-open" ''
  termite -e "$*"
''); in

{
  home-manager.users.isaac = {
    home.packages = with pkgs; [
      (termite-open)
      termite
    ];

    gtk.gtk3.extraCss = ''
      .termite {
        padding: 14px;
      }
    '';

    xdg.configFile = {
      "termite/config".source = termite-config;
      # "gtk-3.0/gtk.css".source = gtk-css;
    };
  };

  # programs.termite = {
  #   enable = true;
  #   allowBold = true;
  #   audibleBell = false;
  # };
}