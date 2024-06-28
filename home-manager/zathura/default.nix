{ pkgs, ...}: {
  programs.zathura = {
    enable = true;

    mappings = {
        # keybindings
        "[fullscreen] a" = "adjust_window best-fit";
        "[fullscreen] s" = "adjust_window width";
        "[fullscreen] f" = "follow";
        "[fullscreen] <Tab>" = "toggle_index";
        "c" = "set recolor false";
    };

    extraConfig = ''
      set recolor true
    '';
  };
}
