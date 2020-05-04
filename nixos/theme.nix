{ pkgs, ... }:

with import <nixpkgs> {};

let
  username = (import ./settings.nix).username;
  theme = (import ./settings.nix).theme;
  font = (import ./settings.nix).font;
in

{
  fonts = {
    fonts = with pkgs; [
      symbola
      unifont
      unifont_upper
      latinmodern-math
      corefonts
      vistafonts
      nerdfonts
      dejavu_fonts
    ];

    fontconfig = {
      # dpi = 96;
      antialias = true;
      hinting.enable = true;

      defaultFonts = {
        monospace = [ font.mono ];
        emoji = [ "Unifont" "Unifont Upper" "Symbola" "Latin Modern Math" font.mono ];
        sansSerif = [ font.sansSerif ];
        serif = [ font.serif ];
      };

      penultimate.enable = true;

      allowBitmaps = true;
      useEmbeddedBitmaps = false;
    };

    enableDefaultFonts = false;
    enableFontDir = true;
  };

  gtk.iconCache.enable = true;

  # Use librsvg's gdk-pixbuf loader cache file as it enables gdk-pixbuf to load SVG files (important for icons)
  environment.sessionVariables = {
    GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
  };

  home-manager.users."${username}" = {
    home.file = {
      ".icons".source = "${pkgs.numix-icon-theme}/share/icons";
    };

    gtk = {
      enable = true;

      font = {
        name = "${font.mono} ${toString font.size}";
      };

      theme = {
        name = "oomox-gtk-gruvbox";
        package =
          (stdenv.mkDerivation rec {
            name = "oomox-gtk-gruvbox";
            src = pkgs.fetchFromGitHub {
              owner = "leomarchand51";
              repo = "oomox-gtk-gruvbox";
              rev = "28ad6358a1753d3472e81970c23d97f1e78f497b";
              sha256 = "1ak9n12aacf9s042k7azx4gyzcpmyfl7dk4nzsbpihwx8aavxkv3";
            };

            dontBuild = true;
            installPhase = ''
              mkdir -p $out/share/themes/oomox-gtk-gruvbox/
              cp -r . $out/share/themes/oomox-gtk-gruvbox/
            '';
          });
      };

      # iconTheme = {
      #   name = theme.iconTheme.name;
      #   package = theme.iconTheme.package;
      # };

      iconTheme = {
        name = "Numix";
        package = pkgs.numix-icon-theme;
      };

      # iconTheme = {
      #   name = "gruvbox-dark-icons-gtk";
      #   package =
      #     (stdenv.mkDerivation rec {
      #       name = "gruvbox-dark-icons-gtk";
      #       src = pkgs.fetchFromGitHub {
      #         owner = "jmattheis";
      #         repo = "gruvbox-dark-icons-gtk";
      #         rev = "4a247a56c78575e19b0e1a4e212b7afcb46499cc";
      #         sha256 = "1fks2rrrb62ybzn8gqan5swcgksrb579vk37bx4xpwkc552dz2z2";
      #       };

      #       installPhase = ''
      #         mkdir -p $out/share/icons/gruvbox-dark-icons-gtk/
      #         cp -r . $out/share/icons/gruvbox-dark-icons-gtk/
      #       '';

      #       nativeBuildInputs = [ gtk3 ];
      #       propagatedBuildInputs = [ hicolor-icon-theme ];
      #       dontDropIconThemeCache = true;

      #       postFixup = ''
      #         for theme in $out/share/icons/*; do
      #           gtk-update-icon-cache $theme
      #         done
      #       '';
      #     });
      # };
    };
  };
}
