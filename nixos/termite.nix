{ pkgs, ... }:

let toggle-lock = "/tmp/termite-scratchpad-toggle.lock"; in

{
  environment.systemPackages =
    let termite-open = (pkgs.writeShellScriptBin "termite-open" ''
      ${pkgs.termite}/bin/termite -e "$*"
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
      termite
    ];

  home-manager.users.isaac = {
    gtk.gtk3.extraCss = ''
      .termite {
        padding: 14px;
      }
    '';

    xdg.configFile = {
      "termite/config".text =
        (builtins.readFile (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/khamer/base16-termite/8f34cab45ebcd73f23321f82204532353edf581f/themes/base16-atelier-sulphurpool.config";
          sha256 = "0kab000aj67sip821rj2aka80jrphh9k125k7gc88mqz3ac7i33r";
        })) + ''
          [options]
          font = FontAwesome 9px
          font = Unifont Upper 14px
          font = Unifont 14px
          font = GohuFont 14px
        '';
    };
  };
}
