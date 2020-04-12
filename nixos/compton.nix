{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
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
              # dbus.Lib
              dbus-glib.dev
            ]);
            postPatch = null;
        })); in {
          enable = true;
          backend = "glx";

          package = compton-animated;

          shadow = true;
          shadowOffsets = [ (-6) (-6) ];
          shadowOpacity = "0.3";
          shadowExclude = [
            "name != 'mpvscratchpad'"
          ];

          vSync = "drm";

          # transition-length length of animation in milliseconds (default: 300)
          # transition-pow-x animation easing on the x-axis (default: 1.5)
          # transition-pow-y animation easing on the y-axis (default: 1.5)
          # transition-pow-w animation easing on the window width (default: 1.5)
          # transition-pow-h animation easing on the window height (default: 1.5)
          # size-transition whether to animate window size changes (default: true)
          # spawn-center-screen whether to animate new windows from the center of the screen (default: false)
          # spawn-center whether to animate new windows from their own center (default: true)
          # no-scale-down

          extraOptions = ''
            transition-length = 50;

            shadow-radius = 4;
            paint-on-overlay = true;
          '';
        };
  };
}
