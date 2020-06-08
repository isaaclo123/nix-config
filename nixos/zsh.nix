{ pkgs, ... }:

let
  # fzf-theme = builtins.fetchurl {
  #   url = "https://raw.githubusercontent.com/nicodebo/base16-fzf/b0dcab770ccdff79413cb46a2e1e0b56fdf48493/bash/base16-gruvbox-dark-hard.config";
  #   sha256 = "07fxl6w7kdsjgzakk68asr4mb4rr1783d6gal01ykba3iblkw335";
  # };
  fzf-theme = pkgs.writeShellScript "gruvbox.config" ''
    # Base16 Gruvbox dark, hard
    # Author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)

    _gen_fzf_default_opts() {

    local color00='#1d2021'
    local color01='#3c3836'
    local color02='#504945'
    local color03='#665c54'
    local color04='#bdae93'
    local color05='#d5c4a1'
    local color06='#ebdbb2'
    local color07='#fbf1c7'
    local color08='#fb4934'
    local color09='#fe8019'
    local color0A='#fabd2f'
    local color0B='#b8bb26'
    local color0C='#8ec07c'
    local color0D='#83a598'
    local color0E='#d3869b'
    local color0F='#d65d0e'

    # bg = -1 instead of 01 for transparent background
    export FZF_DEFAULT_OPTS="
      --color=bg+:$color01,bg:-1,spinner:$color0C,hl:$color0D
      --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
      --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
    "

    }

    _gen_fzf_default_opts
  '';
in

{
  environment.systemPackages = with pkgs; [
    zsh
    oh-my-zsh
    direnv
    z-lua

    ripgrep
    fzf
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
      # "ssh-agent"
      "vi-mode"
      "colored-man-pages"
      "history-substring-search"
    ];
    theme = "clean";
    # cacheDir = "/tmp/.ohmyzsh-$USER";
    customPkgs = with pkgs; [
      zsh-completions
      nix-zsh-completions
    ];
  };

  # zprofile (once, before zshrc)
  # programs.zsh.loginShellInit = ''
  # '';

  # zshrc (start)
  programs.zsh.enableGlobalCompInit = true;

  programs.zsh.interactiveShellInit = ''
    # disable ctrl-d EOF
    stty eof undef

    # disable ctrl-s ctrl-q keybinds in terminal
    stty -ixon

    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

    # z-lua
    eval "$(${pkgs.z-lua}/bin/z --init zsh)"
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

    source ${pkgs.fzf-zsh}/share/zsh/plugins/fzf-zsh/fzf-zsh.plugin.zsh
    source ${fzf-theme}

    eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
  '';

  programs.zsh.shellAliases = with pkgs; {
    c = "clear";
  };

  environment.variables = {
    # FZF_DEFAULT_OPTS = "--extended";
    FZF_DEFAULT_COMMAND="${pkgs.ripgrep}/bin/rg --files --no-ignore --hidden --follow --glob '!.git/*'";
  };

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
