{ pkgs, ... }:

with import <nixpkgs> {};

let username = (import ./settings.nix).username; in

{
  fonts = {
    fonts = with pkgs; [
      unifont
      unifont_upper
      dejavu_fonts
      gohufont
      font-awesome_4
      corefonts
      vistafonts
    ];

    fontconfig = {
      # dpi = 96;

      defaultFonts = {
        monospace = [ "GohuFont" ];
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
      };

      ultimate.enable = false;
      penultimate.enable = true;

      # useEmbeddedBitmaps = true;
    };

    enableDefaultFonts = true;
    enableFontDir = true;
  };

  home-manager.users."${username}" = {
    gtk = {
      enable = true;

      font = {
        name = "GohuFont 14";
        package = pkgs.gohufont;
      };

      theme = {
        name = "oomox-sulphurpool";
        package =
          (stdenv.mkDerivation rec {
            name = "oomox-sulphurpool";
            src = pkgs.fetchFromGitHub {
              owner = "isaaclo123";
              repo = "oomox-sulphurpool-theme";
              rev = "fdac1d11b5c7dd01ef483fdac6096e84e43ed7ed";
              sha256 = "1x6c7hg8bq3zy7py0sj75inmypxx2psgc73myipgqx1bx01qml1g";
            };

            dontBuild = true;
            installPhase = ''
              mkdir -p $out/share/themes/oomox-sulphurpool/
              cp -r . $out/share/themes/oomox-sulphurpool/
            '';
          });
      };

      iconTheme = {
        name = "oomox-sulphurpool";
        package =
          (stdenv.mkDerivation rec {
            name = "oomox-sulphurpool";
            src = pkgs.fetchFromGitHub {
              owner = "isaaclo123";
              repo = "oomox-sulphurpool-icons";
              rev = "99c8b56dddb889d3ee6f9821d8294136c4e8d535";
              sha256 = "183y5j9342vwh2h6fmcfs2zsqskni87f1p7n4grjx9yd6a1fdgr7";
            };

            dontBuild = true;
            installPhase = ''
              mkdir -p $out/share/icons/oomox-sulphurpool/
              cp -r . $out/share/icons/oomox-sulphurpool/
            '';
          });
      };
    };
  };
}
