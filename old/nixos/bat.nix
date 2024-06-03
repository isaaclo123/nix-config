{ config, pkgs, lib, ... }:

let
  username = (import ./settings.nix).username;
  theme = (import ./settings.nix).theme;
in

let bat-theme-name = theme.name; in

let bat-syntax-map-string = syntax-map:
  lib.concatMapStringsSep "\n"
    (key: "--map-syntax ${key}:${builtins.getAttr key syntax-map}")
    (builtins.attrNames syntax-map); in

{
  environment.systemPackages = with pkgs; [
    bat
  ];

  # system.userActivationScripts.batSetup = {
  #   text = ''
  #     ${pkgs.bat}/bin/bat cache --build
  #   '';
  #   deps = [ ];
  # };

  home-manager.users."${username}" = {
    xdg.configFile = {
      "bat/config".text =
        let bat-syntax-map = {
          h="cpp";
          ".ignore"=".gitignore";
          cfg="ini";
          conf="ini";
          scss="css";
        }; in ''
        # Set the theme to "TwoDark"
        --theme="${bat-theme-name}"

        # Show line numbers, Git modifications and file header (but no grid)
        --style="changes,header"

        # Use italic text on the terminal (not supported on all terminals)
        --italic-text=always

        # Add mouse scrolling support in less (does not work with older
        # versions of "less")
        --pager="less -FR"

        # tabs as 4
        --tabs=4

        # no wrap
        --wrap=never

        # syntax mappings
        ${(bat-syntax-map-string bat-syntax-map)}
      '';

      "bat/themes/${bat-theme-name}/${bat-theme-name}.tmTheme".source =
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/peaceant/gruvbox/e3db74d0e5de7bc09cab76377723ccf6bcc64e8c/gruvbox.tmTheme";
          sha256= "1lwjyd2x25csr1ssamjjrj042dkjziy2v7yp579x3ps1bym43zs3";
        });

      "bat/syntaxes/vue-syntax-highlight".source =
        (pkgs.fetchFromGitHub {
          owner = "vuejs";
          repo = "vue-syntax-highlight";
          rev = "6d405948df4a112eb7a4db2ed72bbfe76dd9f419";
          sha256 = "08lq0p59ybl5xv0yi19c62xrzgw8b3h74vzfdsrfaxz7a7hlwvs1";
        });
    };
  };
}
