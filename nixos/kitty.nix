{ pkgs, ... }:

let atelier-sulphurpool-kitty-theme = pkgs.fetchurl {
  url = "https://raw.githubusercontent.com/dexpota/kitty-themes/a84b8061763ceaee032b3c5eea66c5e3061bf052/themes/AtelierSulphurpool.conf";
  sha256 = "0akxs1fchhw5yfbh4b4fhkiby7h1glk622bad9x3449v9yr0czq3";
}; in

let kitty-config = (pkgs.writeText "kitty.conf" ''
  include ${atelier-sulphurpool-kitty-theme}

  font_family GohuFont
  bold_font GohuFont Bold
  italic_font GohuFont Italic
  bold_italic_font GohuFont Bold Italic
  font_size 14.0
  window_margin_width 14.0
''); in

let kitty-open = (pkgs.writeShellScriptBin "kitty-open" ''
  kitty -e "$*"
''); in

{
  environment.systemPackages = with pkgs; [
    (kitty-open)
    kitty
    st
  ];

  home-manager.users.isaac = {
    xdg.configFile = {
      "kitty/kitty.conf".source = kitty-config;
    };
  };

  # programs.termite = {
  #   enable = true;
  #   allowBold = true;
  #   audibleBell = false;
  # };
}
