with import <nixpkgs> {};

{
  username = "isaac";
  fullname = "Isaac Lo";

  homedir = "/home/isaac";
  server-url = "vps.isaaclo.site";
  dav-url = "https://vps.isaaclo.site/radicale/isaac/";

  font = {
    mono = "Iosevka Nerd Font";
    sansSerif = "DejaVu Sans";
    serif = "DejaVu Serif";

    size = 10;
  };

  spacing = {
    padding = 20;
    border = 1;
  };

  opacity = {
    inactive = 0.85;
    active = 1.0;
  };

  color = rec {
    red = "fb4934";
    green = "b8bb26";
    yellow = "fabd2f";
    blue = "83a598";
    purple = "d3869b";
    cyan = "8ec07c";
    orange = "fe8019";
    gray = "928374";

    # darkgray = "32302f";
    darkgray = "3c3836";

    black = "1d2021";
    white = "ebdbb2";


    alt = rec {
      red = "cc241d";
      green = "98971a";
      yellow = "d79921";
      blue = "458588";
      purple = "b16286";
      cyan = "689d6a";
      orange = "d65d0e";
      gray = "a89984";
      darkgray = "3c3836";

      black = "282828";
      white = "fbf1c7";

      bg = black;
      fg = white;
    };

    ac = blue;
    fg = white;
    bg = black;
  };

  theme = {
    name = "gruvbox";
    background = "dark";
    wallpaper = "/etc/nixos/wallpaper.jpg";
  };

  rofi = rec {
    style = "style_normal_grid";
    colorscheme = "gruvbox";
    args = "-theme launchers/${style}.rasi -no-show-icons";
  };

  icon = rec {
    pkg = pkgs.numix-icon-theme;
    name = "Numix";
    size = "48";

    path = "${pkg}/share/icons/${name}/${size}";
  };
}
