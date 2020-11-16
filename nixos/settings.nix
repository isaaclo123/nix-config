with import <nixpkgs> {};

let
  opacity-hex = opacity-int:

  let
    opacity-str = builtins.toString opacity-int;
    opacity-dict = {
      "100" = "ff";
      "95" = "f2";
      "90" = "e6";
      "85" = "d9";
      "80" = "cc";
      "75" = "bf";
      "70" = "b3";
      "65" = "a6";
      "60" = "99";
      "55" = "8c";
      "50" = "80";
      "45" = "73";
      "40" = "66";
      "35" = "59";
      "30" = "4d";
      "25" = "40";
      "20" = "33";
      "15" = "26";
      "10" = "1a";
      "5" = "0d";
      "0" = "00";
    };
  in
  opacity-dict."${opacity-str}";
in

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

    nerdFonts = [
      "Iosevka"
    ];

    size = 10;
  };

  spacing = {
    padding = 20;
    border = 2;
  };

  opacity = rec {
    inactive-int = 85;
    active-int = 100;

    inactive = inactive-int * 0.01;
    active = active-int * 0.01;

    inactive-hex = opacity-hex inactive-int;
    active-hex = opacity-hex active-int;

    background-transparent = "rgba(29,32,33,${builtins.toString (inactive)})";
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
    size = "32";

    path = "${pkg}/share/icons/${name}/${size}";
  };
}
