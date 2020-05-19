{ config, pkgs, lib, ... }:

let
  username = (import ./settings.nix).username;
  theme = (import ./settings.nix).theme;
in


{
  environment.systemPackages = with pkgs; [
    ripgrep
    fzf
  ];

  environment.variables = {
    # NOTMUCH_CONFIG = "/home/isaac/.config/notmuch/notmuchrc";
    # shorter delay on cmd-mode
    # KEYTIMEOUT = "1";
    # LESS = "-erFX";
    # FZF_TMUX = "1";
    # FZF_DEFAULT_COMMAND = "${pkgs.ag}/bin/ag -f -g '' --hidden --depth 16 --ignore dosdevices";
    # FZF_CTRL_T_COMMAND = "${pkgs.ag}/bin/ag -f -g '' --hidden --depth 16 --ignore dosdevices";
    # FZF_DEFAULT_OPTS = "-m --ansi --color=16,bg:-1,bg+:-1 --tac";
    # FZF_ALT_C_COMMAND = "find -L . -maxdepth 16 -type d 2>/dev/null";
    FZF_DEFAULT_OPS = "--extended";
    FZF_DEFAULT_COMMAND="${pkgs.ripgrep}/bin/rg --files --no-ignore --hidden --follow --glob '!.git/*'";
  };
}
