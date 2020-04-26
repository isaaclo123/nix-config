{ config, pkgs, ... }:

let
  username = (import ./settings.nix).username;
  theme = (import ./settings.nix).theme;
  font = (import ./settings.nix).font;
  color = (import ./settings.nix).color;

  # fontname = "Iosevka-Medium-Nerd-Font-Complete-Mono";
  # font = (import ./settings.nix).font;
in

{
  environment.systemPackages =
    let
      lock = (pkgs.writeShellScriptBin "lock" ''
        mpc pause &>/dev/null
        # amixer set Master mute
        ${pkgs.betterlockscreen}/bin/betterlockscreen "$@" blur
      '');
    in with pkgs; [
      (lock)
      betterlockscreen
    ];

    # system.userActivationScripts.betterlockscreenSetup = {
    #   text = ''
    #     ${pkgs.betterlockscreen}/bin/betterlockscreen -u ${theme.wallpaper} -b
    #   '';
    #   deps = [ ];
    # };

  home-manager.users."${username}" = {
    xdg.configFile = {
      "betterlockscreenrc".text = ''
        insidecolor=00000000
        ringcolor=${color.white}ff
        keyhlcolor=${color.blue}ff
        bshlcolor=${color.blue}ff
        separatorcolor=00000000
        insidevercolor=00000000
        insidewrongcolor=${color.red}ff
        ringvercolor=${color.white}ff
        ringwrongcolor=${color.white}ff
        verifcolor=${color.white}ff
        timecolor=${color.white}ff
        datecolor=${color.white}ff
        loginbox=${color.black}e6 # 90% color
        font="${font.mono}"
        locktext='Type password to unlock...'
        lock_timeout=1
      '';
    };
  };
}
