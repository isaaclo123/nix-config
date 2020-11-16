{ pkgs, ... }:

with import <nixpkgs> {};

let
  username = (import ./settings.nix).username;
  theme = (import ./settings.nix).theme;
  font = (import ./settings.nix).font;
  icon = (import ./settings.nix).icon;
in

# let nerdfonts-derivation =
#   (with import <nixpkgs> {};
#     stdenv.lib.overrideDerivation pkgs.nerdfonts (oldAttrs : {
#       src = builtins.fetchurl {
#         url = "https://github.com/ryanoasis/nerd-fonts/archive/2.0.0.tar.gz";
#         sha256 = "1j3v7s1w3kyygkl0mwl1cyy6q11c7ldqfapfh6djsfzz5q23jn8d";
#       };
#   })); in

{
  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = font.nerdFonts;
      })
      symbola
      unifont
      unifont_upper
      latinmodern-math
      corefonts
      vistafonts
      # nerdfonts
      # (nerdfonts-derivation)
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
      ".icons".source = "${icon.pkg}/share/icons";
    };

    gtk = {
      enable = true;

      font = {
        name = "${font.mono} ${toString font.size}";
      };

      theme = {
        name = "gruvbox-gtk";
        package =
          (stdenv.mkDerivation rec {
            name = "oomox-gtk-gruvbox";
            src = pkgs.fetchFromGitHub {
              owner = "3ximus";
              repo = "gruvbox-gtk";
              rev = "fda45c127bd5ed3cdd2dfcc6c396e7aef99abd8e";
              sha256 = "1vlgsp7hgf96bzlj54rimmimzhpchh3z3a4fll71wxghr3gpv27d";
            };

            dontBuild = true;
            installPhase = ''
              mkdir -p $out/share/themes/gruvbox-gtk/
              cp -r . $out/share/themes/gruvbox-gtk/
            '';
          });
      };

      iconTheme = {
        name = icon.name;
        package = icon.pkg;
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
