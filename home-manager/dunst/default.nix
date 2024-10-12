{ pkgs, lib, ...}: {
  home.packages = [
    pkgs.libnotify
  ];

  stylix = {
    targets.dunst.enable = false;
  };

  services.dunst = {
    enable = true;

    # configFile = ./dunstrc;

    # iconTheme = {
    #   name = "rose-pine-icon-theme";
    #   package = pkgs.rose-pine-icon-theme;
    #   size = "32";
    # };

    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        geometry = "300x60-20+20";
        indicate_hidden = true;
        shrink = false;
        separator_height = 0;
        padding = 16;
        horizontal_padding = 16;
        frame_width = 2;
        sort = false;
        idle_threshold = 120;
        font = "OperatorMono Nerd Font 10";
        corner_radius = 4;
        line_height = 4;
        markup = "full";
        format = "<b><i>%s</i></b>\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = true;
        ignore_newline = false;
        stack_duplicates = false;
        hide_duplicate_count = true;
        show_indicators = false;
        icon_position = "left";
        enable_recursive_icon_lookup = true;
        sticky_history = true;
        history_length = 20;
        browser = "qutebrowser";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
      };

      shortcuts = {
        # Shortcuts are specified as [modifier+][modifier+]...key
        # Available modifiers are "ctrl", "mod1" (the alt-key), "mod2",
        # "mod3" and "mod4" (windows-key).
        # Xev might be helpful to find names for keys.

        # Close notification.
        close = "ctrl+space";

        # Close all notifications.
        close_all = "ctrl+shift+space";

        # Redisplay last message(s).
        # On the US keyboard layout "grave" is normally above TAB and left
        # of "1".
        history = "ctrl+esc";

        # Context menu.
        context = "ctrl+period";
      };

      urgency_low = {
        icon = "${pkgs.rose-pine-icon-theme}/share/icons/rose-pine/32x32/status/dialog-information.svg";
        background = "#1f1d2e";
        foreground = "#e0def4";
        frame_color = "#31748f";
        timeout = 4;
      };

      urgency_normal = {
        icon = "${pkgs.rose-pine-icon-theme}/share/icons/rose-pine/32x32/status/dialog-warning.svg";
        background = "#1f1d2e";
        foreground = "#e0def4";
        frame_color = "#c4a7e7";
        timeout = 5;
      };

      urgency_critical = {
        icon = "${pkgs.rose-pine-icon-theme}/share/icons/rose-pine/32x32/status/dialog-error.svg";
        background = "#1f1d2e";
        foreground = "#e0def4";
        frame_color = "#eb6f92";
        timeout = 8;
      };
    };
  };
}
