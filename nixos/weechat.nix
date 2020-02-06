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

        vimode = attrs: {
          src = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/GermainZ/weechat-vimode/4e926c39bd21de15c146e2a0bea1b85684ef08f2/vimode.py";
            sha256 = "0wjvh08rdlpxfm1k770hpi2f7qkfm8vszcm4qk7hag63crpd78kp";
          };
        };

        urlbuf = attrs: {
          src = pkgs.fetchurl {
            url = "https://weechat.org/files/scripts/urlbuf.py";
            sha256 = "0zfmjknz9fx82vz682na3xv5f972grga67mgk3wsjrljyn1j2svn";
          };
        };

        url_hint = attrs: {
          src = pkgs.fetchurl {
            url = "https://weechat.org/files/scripts/url_hint.py";
            sha256 = "0aw59kq74yqh0qbdkldfl6l83d0bz833232xr2w4741szck43kss";
          };
        };
      };

      weechat_notify_send = (with import <nixpkgs> {};
        stdenv.mkDerivation rec {
          pname = "weechat-notify-send";
          version = "0.9";

          src = pkgs.fetchFromGitHub {
            owner = "s3rvac";
            repo = "weechat-notify-send";
            rev = "b491e6acc1fe00fd1b91409444f9904587b2e588";
            sha256 = "1f9558a78ismd645c9v6p3lgda6hkgn3f63i8s4y5r8zdymx08d0";
          };

          passthru.scripts = [ "notify_send.py" ];
          installPhase = ''
            install -D notify_send.py $out/share/notify_send.py
          '';
        });

      scripts = pkgs.unstable.callPackage "${nixos-weechat}/scripts.nix" {
        inherit defaultWeechatScriptOverrides;
      }; in

      with pkgs; [
        (unstable.weechat.override {
          configure = { availablePlugins, ... }: {
            plugins = builtins.attrValues availablePlugins;

            scripts = with scripts; [
              # python
              apply_corrections
              auto_away
              # autoconf
              autoconnect
              autojoin
              autosort
              bitlbee_completion
              auto_away
              buffer_autoclose
              bitlbee_typing_notice
              colorize_nicks
              go
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
              grep
              weechat_notify_send

              # perl
              atcomplete
              highmon
              iset
              perlexec
              pv_info
              # multiline
            ];
          };
        })

        aspell
        scowl
      ];
}
