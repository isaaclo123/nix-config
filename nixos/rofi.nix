{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  font = (import ./settings.nix).font;
in

{
  environment.systemPackages = with pkgs; [
    rofi
  ];

  home-manager.users."${username}" = {
    xdg.configFile = {
      "rofi/gruvbox-common.rasi".source =
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/bardisty/gruvbox-rofi/0b4cf703087e2150968826b7508cf119437eba7a/gruvbox-common.rasi";
          sha256= "1y7xrgm3443pag3nm287g9pdzcqynh8zpys7l6wiyhx2frv6dl8k";
        });

      "rofi/gruvbox-dark-hard.rasi".source =
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/bardisty/gruvbox-rofi/0b4cf703087e2150968826b7508cf119437eba7a/gruvbox-dark-hard.rasi";
          sha256= "1w59bc6amhdyyznvznwbzj445dy214mrl3zx5h74x4h1p47jsx4b";
        });

      "rofi/config.rasi".text = ''
        window {
          font: "${font.mono} ${toString font.size}";
        }

        @import "gruvbox-dark-hard.rasi"
      '';
    };
  };
}
