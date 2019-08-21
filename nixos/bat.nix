{ pkgs, lib, ... }:

with import <nixpkgs> {};

let bat-theme-name = "base16-atelier-sulphurpool"; in

let bat-syntax-map = {
  h="cpp";
  ".ignore"=".gitignore";
  cfg="ini";
  conf="ini";
}; in

let bat-syntax-map-string = syntax-map:
  lib.concatMapStringsSep "\n"
    (key: "--map-syntax ${key}:${builtins.getAttr key syntax-map}")
    (builtins.attrNames syntax-map); in

let bat-config = (pkgs.writeText "config" ''
  # Set the theme to "TwoDark"
  --theme="${bat-theme-name}"

  # Show line numbers, Git modifications and file header (but no grid)
  --style="changes,header"

  # Use italic text on the terminal (not supported on all terminals)
  --italic-text=always

  # Add mouse scrolling support in less (does not work with older
  # versions of "less")
  --pager="less -FR"

  ${(bat-syntax-map-string bat-syntax-map)}

  # tabs as 4
  --tabs=4

  --wrap=never
''); in

let bat-theme = pkgs.fetchurl {
  url = "https://raw.githubusercontent.com/chriskempson/base16-textmate/cab66929126a14acafe37cf9c24c9e700716cd5a/Themes/base16-atelier-sulphurpool.tmTheme";
  sha256= "01zi9kpylbkvd9anwqgqjad8qc6nnyaqbmjacfy9vaz5fvm9ki3j";
}; in

let vue-syntax-highlight = pkgs.fetchFromGitHub {
  owner = "vuejs";
  repo = "vue-syntax-highlight";
  rev = "6d405948df4a112eb7a4db2ed72bbfe76dd9f419";
  sha256 = "08lq0p59ybl5xv0yi19c62xrzgw8b3h74vzfdsrfaxz7a7hlwvs1";
}; in

# let bat-derivation = stdenv.lib.overrideDerivation pkgs.bat (oldAttrs : {
#   postInstall = oldAttrs.postInstall or "" + ''
#     export BAT_CONFIG_PATH=/home/isaac/.config/bat
#     ${pkgs.bat}/bin/bat cache --build
#   '';
# }); in

{
  environment.systemPackages = with pkgs; [
    bat
  ];

  home-manager.users.isaac = {
    xdg.configFile = {
      "bat/config".source = bat-config;
      "bat/themes/${bat-theme-name}/${bat-theme-name}.tmTheme".source = bat-theme;
      "bat/syntaxes/vue-syntax-highlight".source = vue-syntax-highlight;
    };
  };
}
