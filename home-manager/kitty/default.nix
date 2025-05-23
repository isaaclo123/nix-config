{ pkgs, ...}: {
  programs.kitty = {
    enable = true;
    extraConfig = ''
      confirm_os_window_close 0
      single-instance 1

      window_padding_width 6
    '';
    shellIntegration.enableFishIntegration = true;
  };

  home.sessionVariables = {
    TERM = "xterm-kitty";
  };
}
