{ pkgs, ... }:

let nixos-weechat = (with import <nixpkgs> {};
  stdenv.mkDerivation rec {
    name = "nixos-weechat";
    src = pkgs.fetchFromGitHub {
      owner = "andir";
      repo = "nixos-weechat";
      rev = "9e01b820a9f1963da4ae56ec85929d0d92c40fcb";
      sha256 = "1yb9i55857cfsaakzngz0cln8mlrjhfp23r2jh8ysqdhamlsy5qm";
    };

    dontBuild = true;
    installPhase = ''
      cp -r . $out/
    '';
  }); in

{
  environment.systemPackages =
    let
      defaultWeechatScriptOverrides = {
        pv_info = attrs: {
          src = pkgs.fetchurl {
            # https://gist.github.com/isaaclo123/3d5e075cdcae9345447dc4f16cf9c510
            # pv_info_colorize_nicks
            url = "https://gist.githubusercontent.com/isaaclo123/3d5e075cdcae9345447dc4f16cf9c510/raw/9e208ffbcfcfe3172a58616eb8fdc77266ccc989/pv_info_colorize_nicks.pl";
            sha256 = "0bcfd7mnwcij746221a4b50hj11b24kl1ggyqj72gg8v4vqh9f71";
          };
        };
      };

      scripts = pkgs.unstable.callPackage "${nixos-weechat}/scripts.nix" {
        inherit defaultWeechatScriptOverrides;
      }; in

      with pkgs; [
        (weechat.override {
          configure = { availablePlugins, ... }: {
            plugins = builtins.attrValues availablePlugins;

            scripts = with scripts; [
              # python
              autojoin
              apply_corrections
              auto_away
              autoconf
              autoconnect
              autojoin
              autosort
              bitlbee_completion
              buffer_autoclose
              colorize_nicks
              go
              notify_send
              screen_away
              server_autoswitch
              spell_correction
              url_hint
              urlbuf
              urlserver
              vimode
              zerotab
              zncnotice
              zncplayback

              # perl
              atcomplete
              highmon
              iset
              perlexec
              pv_info
            ];
          };
        })
      ];
}
