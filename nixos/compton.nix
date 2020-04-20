{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  opacity = (import ./settings.nix).opacity;
in

{
  home-manager.users."${username}" = {
    # compton
    services.compton =
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
        })); in {
          enable = true;
          backend = "glx";

          package = compton-animated;

          shadow = true;
          shadowOffsets = [ (-9) (-9) ];
          shadowOpacity = "0.4";

          activeOpacity = toString opacity.active;
          inactiveOpacity = toString opacity.inactive;
          menuOpacity = toString opacity.inactive;

          blur = true;
          fade = true;
          fadeDelta = 3;

          vSync = "drm";

          extraOptions = ''
            focus-exclude = [
              "name = 'i3lock'"
            ];

            transition-pow-x = 1.0;
            transition-pow-y = 1.0;
            transition-pow-w = 1.0;
            transition-pow-h = 1.0;
            size-transition = true;
            spawn-center-screen = false;
            spawn-center = false;
            no-scale-down = false;

            shadow-radius = 6;
            transition-length = 65;
            paint-on-overlay = true;
          '';
        };
  };
}
