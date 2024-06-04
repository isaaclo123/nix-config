{ pkgs, ... }: {
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
  };

  home.sessionVariables = {
    PASSWORD_STORE_DIR = "$HOME/.password-store";
  };
}
