{ pkgs, ... }:

with import <nixpkgs> {};

let
  username = (import ./settings.nix).username;
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
    ];

    fontconfig = {
      # dpi = 96;

      defaultFonts = {
        monospace = [ font.mono ];
        emoji = [ "Unifont" "Unifont Upper" "Symbola" "Latin Modern Math" font.mono ];
        sansSerif = [ font.mono ];
        serif = [ font.mono ];
      };

      ultimate.enable = true;
      penultimate.enable = false;

      allowBitmaps = true;
      useEmbeddedBitmaps = false;
    };

    enableDefaultFonts = false;
    enableFontDir = true;
  };

  home-manager.users."${username}" = {
    gtk = {
      enable = true;

      font = {
        name = "${font.mono} ${toString font.size}";
      };

      theme = {
        name = "gruvbox-dark-gtk";
        package =
          (stdenv.mkDerivation rec {
            name = "gruvbox-dark-gtk";
            src = pkgs.fetchFromGitHub {
              owner = "jmattheis";
              repo = "gruvbox-dark-gtk";
              rev = "a02c2286855a7fea3d5f17e2257c78f961afc944";
              sha256 = "1j6080bvhk5ajmj7rc8sdllzz81iyafqic185nrqsmlngvjrs83h";
            };

            dontBuild = true;
            installPhase = ''
              mkdir -p $out/share/themes/gruvbox-dark-gtk/
              cp -r . $out/share/themes/gruvbox-dark-gtk/
            '';
          });
      };

      iconTheme = {
        name = "gruvbox-dark-icons-gtk";
        package =
          (stdenv.mkDerivation rec {
            name = "gruvbox-dark-icons-gtk";
            src = pkgs.fetchFromGitHub {
              owner = "jmattheis";
              repo = "gruvbox-dark-icons-gtk";
              rev = "4a247a56c78575e19b0e1a4e212b7afcb46499cc";
              sha256 = "1fks2rrrb62ybzn8gqan5swcgksrb579vk37bx4xpwkc552dz2z2";
            };

            dontBuild = true;
            installPhase = ''
              mkdir -p $out/share/icons/gruvbox-dark-icons-gtk/
              cp -r . $out/share/icons/gruvbox-dark-icons-gtk/
            '';
          });
      };
    };
  };
}
