{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zsh
    oh-my-zsh
  ];

  programs.zsh.enable = true;
  programs.zsh.autosuggestions = {
    enable = true;
    strategy = "match_prev_cmd";
    # highlightStyle = "fg=8";
  };
  programs.zsh.syntaxHighlighting = {
    enable = true;
    # highlighters = [ "main" "brackets" "cursor" "root" "line" ];
  };
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [
      "git"
      "sudo"
      "ssh"
      "vi-mode"
      "colored-man-pages"
      "history-substring-search"
    ];
    theme = "clean";
    # cacheDir = "/tmp/.ohmyzsh-$USER";
    customPkgs = with pkgs;
      [ pkgs.zsh-completions pkgs.nix-zsh-completions ];
  };
  # zprofile (once, before zshrc)
  # programs.zsh.loginShellInit = ''
  # '';
  # zshrc (start)
  programs.zsh.enableGlobalCompInit = true;
  environment.interactiveShellInit = ''
    # disable ctrl-d EOF
    stty eof undef

    # disable ctrl-s ctrl-q keybinds in terminal
    stty -ixon

    # source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

    # z.sh
    . ${import ./z.nix}/bin/z
  '';
  # zshrc (end)
  programs.zsh.promptInit = ''
    # for history-substring-search
    # bind UP and DOWN arrow keys
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down

    # bind UP and DOWN arrow keys (compatibility fallback
    # for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    # bind k and j for VI mode
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down

    # jk for normal mode
    bindkey 'jk' vi-cmd-mode

    # bind C-e and C- for VI mode
    bindkey -M vicmd '^N' history-substring-search-down
    bindkey -M vicmd '^P' history-substring-search-up

    # bind Shift tab for reverse menu complete
    zstyle ':completion:*' menu select
    zmodload zsh/complist
    bindkey -M menuselect '^[[Z' reverse-menu-complete

    # unset XDG_CONFIG_HOME for termite
    unset XDG_CONFIG_HOME
  '';
  programs.zsh.shellAliases = with pkgs; {
    c = "clear";
  };

  # environment.shellInit = ''
  #   gpg-connect-agent /bye
  #   export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  #   echo UPDATESTARTUPTTY | gpg-connect-agent &> /dev/null
  # '';

  # environment.variables = {
  #   # NOTMUCH_CONFIG = "/home/isaac/.config/notmuch/notmuchrc";
  #   # shorter delay on cmd-mode
  #   # KEYTIMEOUT = "1";
  #   # LESS = "-erFX";
  #   # FZF_TMUX = "1";
  #   # FZF_DEFAULT_COMMAND = "${pkgs.ag}/bin/ag -f -g '' --hidden --depth 16 --ignore dosdevices";
  #   # FZF_CTRL_T_COMMAND = "${pkgs.ag}/bin/ag -f -g '' --hidden --depth 16 --ignore dosdevices";
  #   # FZF_DEFAULT_OPTS = "-m --ansi --color=16,bg:-1,bg+:-1 --tac";
  #   # FZF_ALT_C_COMMAND = "find -L . -maxdepth 16 -type d 2>/dev/null";
  # };
}
