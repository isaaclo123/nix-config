{ pkgs, ...}: {
  programs.kitty = {
    enable = true;
    extraConfig = ''
      confirm_os_window_close 0
      single-instance 1
    '';
  };

  home.sessionVariables = {
    TERM = "xterm-256color";
  };
}
