{ pkgs, ... }:

{
  home-manager.users.isaac = {
    home.packages = with pkgs; [
      # notifications
      dunst
      libnotify
    ];

    services.dunst = {
      enable = true;
      settings = {
        global = {
          font = "GohuFont 14px";

          # Allow a small subset of html markup:
          #   <b>bold</b>
          #   <i>italic</i>
          #   <s>strikethrough</s>
          #   <u>underline</u>
          #
          # For a complete reference see
          # <http://developer.gnome.org/pango/stable/PangoMarkupFormat.html>.
          # If markup is not allowed, those tags will be stripped out of the
          # message.
          markup = true;

          # The format of the message.  Possible variables are:
          #   %a  appname
          #   %s  summary
          #   %b  body
          #   %i  iconname (including its path)
          #   %I  iconname (without its path)
          #   %p  progress value if set ([  0%] to [100%]) or nothing
          # Markup is allowed
          format = "<b>%s</b>\\n%b";

          # Sort messages by urgency.
          sort = true;

          # Show how many messages are currently hidden (because of geometry).
          indicate_hidden = true;

          # Alignment of message text.
          # Possible values are "left", "center" and "right".
          alignment = "left";

          # The frequency with wich text that is longer than the notification
          # window allows bounces back and forth.
          # This option conflicts with "word_wrap".
          # Set to 0 to disable.
          bounce_freq = 0;

          # Show age of message if message is older than show_age_threshold
          # seconds.
          # Set to -1 to disable.
          show_age_threshold = 60;

          # Split notifications into multiple lines if they don't fit into
          # geometry.
          word_wrap = true;

          # Ignore newlines '\n' in notifications.
          ignore_newline = false;


          # The geometry of the window:
          #   [{width}]x{height}[+/-{x}+/-{y}]
          # The geometry of the message window.
          # The height is measured in number of notifications everything else
          # in pixels.  If the width is omitted but the height is given
          # ("-geometry x2"), the message window expands over the whole screen
          # (dmenu-like).  If width is 0, the window expands to the longest
          # message displayed.  A positive x is measured from the left, a
          # negative from the right side of the screen.  Y is measured from
          # the top and down respectevly.
          # The width can be negative.  In this case the actual width is the
          # screen width minus the Width defined in within the geometry option.
          geometry = "300x6-34-34";

          # Shrink window if it's smaller than the width.  Will be ignored if
          # width is 0.
          shrink = false;

          # The transparency of the window.  Range: [0; 100].
          # This option will only work if a compositing windowmanager is
          # present (e.g. xcompmgr, compiz, etc.).
          transparency = 0;

          # Don't remove messages, if the user is idle (no mouse or keyboard input)
          # for longer than idle_threshold seconds.
          # Set to 0 to disable.
          idle_threshold = 120;

          # Which monitor should the notifications be displayed on.
          monitor = 0;

          # Display notification on focused monitor.  Possible modes are:
          #   mouse: follow mouse pointer
          #   keyboard: follow window with keyboard focus
          #   none: don't follow anything
          #
          # "keyboard" needs a windowmanager that exports the
          # _NET_ACTIVE_WINDOW property.
          # This should be the case for almost all modern windowmanagers.
          #
          # If this option is set to mouse or keyboard, the monitor option
          # will be ignored.
          follow = "keyboard";

          # Should a notification popped up from history be sticky or timeout
          # as if it would normally do.
          sticky_history = true;

          # Maximum amount of notifications kept in history
          history_length = 20;

          # Display indicators for URLs (U) and actions (A).
          show_indicators = true;

          # The height of a single line.  If the height is smaller than the
          # font height, it will get raised to the font height.
          # This adds empty space above and under the text.
          line_height = 0;

          # Draw a line of "separatpr_height" pixel height between two
          # notifications.
          # Set to 0 to disable.
          separator_height = 4;

          # Padding between text and separator.
          padding = 14;

          # Horizontal padding.
          horizontal_padding = 14;

          # Define a color for the separator.
          # possible values are:
          #  * auto: dunst tries to find a color fitting to the background;
          #  * foreground: use the same color as the foreground;
          #  * frame: use the same color as the frame;
          #  * anything else will be interpreted as a X color.
          separator_color = "frame";

          # Print a notification on startup.
          # This is mainly for error detection, since dbus (re-)starts dunst
          # automatically after a crash.
          startup_notification = false;

          # dmenu path.
          dmenu = "rofi -dmenu -p dunst";

          # Browser for opening urls in context menu.
          browser = "qutebrowser";

          # Align icons left/right/off
          icon_position = "off";

          # Paths to default icons.
          # icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";

          frame_width = 4;
          frame_color = "#6679cc";
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
          history = "ctrl+grave";

          # Context menu.
          context = "ctrl+period";
        };

        urgency_low = {
          # IMPORTANT: colors have to be defined in quotation marks.
          # Otherwise the "#" and following would be interpreted as a comment.
          background = "#202746";
          foreground = "#6679cc";
          timeout = 5;
        };

        urgency_normal = {
          background = "#202746";
          foreground = "#979db4";
          timeout = 5;
        };

        urgency_critical = {
          background = "#202746";
          foreground = "#c76b29";
          timeout = 5;
        };
      };
    };
  };
}