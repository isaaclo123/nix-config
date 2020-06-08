{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  opacity = (import ./settings.nix).opacity;
in

{
  home-manager.users."${username}" = {
    # compton
    services.picom =
      let compton-animated =
        (with import <nixpkgs> {};
          stdenv.lib.overrideDerivation pkgs.neocomp (oldAttrs : {
            src = fetchFromGitHub {
              owner = "BlackCapCoder";
              repo = "compton";
              rev = "dd5837b5e96eae82567592919d107522c7a53a92";
              sha256 = "0ic5ifasa9gbx5c4yalvh5sdml09pb67vkjcl1k96n7dg9gzr51l";
            };

            buildInputs = oldAttrs.buildInputs ++ (with pkgs; [
              dbus-glib.dev
            ]);

            postPatch = null;

            fixupPhase = ''
              ln -s $out/bin/compton $out/bin/picom
            '';
        })); in {
          enable = true;
          backend = "glx";

          package = compton-animated;

          shadow = true;
          shadowOffsets = [ (-9) (-9) ];
          shadowOpacity = "0.4";

          # activeOpacity = toString opacity.active;
          # inactiveOpacity = toString opacity.inactive;
          menuOpacity = toString opacity.inactive;

          opacityRule = [
            # "${toString opacity.inactive-int}:class_g = 'termite'"
            # "${toString opacity.inactive-int}:class_g = 'Rofi'"
            "${toString opacity.inactive-int}:class_g = 'Zathura'"
          ];

          blur = true;
          fade = true;
          fadeDelta = 4;

          vSync = false;

          extraOptions = ''
            focus-exclude = [
              "name = 'i3lock'",
              "name = 'mpvscratchpad'"
            ];

            transition-pow-x = 0.5;
            transition-pow-y = 0.5;
            transition-pow-w = 0.5;
            transition-pow-h = 0.5;
            size-transition = true;
            spawn-center-screen = false;
            spawn-center = false;
            no-scale-down = true;

            shadow-radius = 6;
            transition-length = 80;
            unredir-if-possible = true;
            paint-on-overlay = true;
          '';
        };
  };
}
