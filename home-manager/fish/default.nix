{ pkgs, inputs, ...}: {

  home.sessionVariables = {
    DIRENV_WARN_TIMEOUT = 0;
    JIRA_API_TOKEN = "$(pass show jira/api_token)";
  };
  programs.direnv = {
    enable = true;
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      # alias ranger "TERM=xterm ${pkgs.ranger}/bin/ranger"
    '';

    plugins = with pkgs.fishPlugins; [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
        };
      }
      {
        name = "autopair";
        src = autopair;
      }
    ];

    functions = {
      fish_user_key_bindings = {
        body = ''
          fish_vi_key_bindings
          bind --mode insert \cd true

          bind -M insert -m default jk backward-char force-repaint

          bind -M insert \cf accept-autosuggestion
          bind \cf accept-autosuggestion

          for mode in insert default visual
            bind -M $mode \ck 'history --merge ; up-or-search'
            bind -M $mode \cj 'history --merge ; down-or-search'
          end
        '';
      };
    };
  };
}
