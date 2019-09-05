{ config, lib, pkgs, ... }:

let homedir = "/home/isaac"; in

let dav-url = "https://vps.myrdd.info/radicale/isaac/"; in

let calcurse-vdirsyncer =
  (with import <nixpkgs> {};
    stdenv.mkDerivation rec {
      name = "calcurse-vdirsyncer";

      src = pkgs.fetchFromGitHub {
        owner = "lfos";
        repo = "calcurse";
        rev = "61d3667899881b8ca17c35b1dbb718c723ecab8e";
        sha256 = "1iw1w5cz1f7p8fc2i89sbbxxmjbxsw8q5jr9r9l1mjlk7kb8v2zd";
        fetchSubmodules = false;
      };

      patches = [
        (pkgs.fetchurl {
          # https://gist.github.com/isaaclo123/f8f46730cf01363aec926206f7524c61
          name = "calcurse-vdirsyncer-fix";
          url = "https://gist.githubusercontent.com/isaaclo123/f8f46730cf01363aec926206f7524c61/raw/93853866e320c67524ef9fea8af300d00135e0d6/calcurse-vdirsyncer-fix.patch";
          sha256 = "1zicfl3qhq53ipbs7xih2p8praswzvqwr7xcmkjczvw6lzmvfvah";
        })
      ];

      dontBuild = true;

      installPhase = ''
        mkdir -p $out/bin
        cp ./contrib/vdir/calcurse-vdirsyncer $out/bin/
        chmod +x $out/bin/calcurse-vdirsyncer
      '';
    }); in

{
  environment.systemPackages = with pkgs; [
    (calcurse-vdirsyncer)
    vdirsyncer
  ];

  systemd.user = {
    timers.calcurse-vdirsyncer = {
      wantedBy = [ "timers.target" ];
      partOf = [ "calcurse-vdirsyncer.service" ];
      timerConfig = {
        OnCalendar = "*:0/30";
      };
    };

    services.calcurse-vdirsyncer = {
      description = "calcurse-vdirsyncer systemd service";

      requiredBy = [ "nixos-activation.service" ];
      after = [ "nixos-activation.service" ];

      serviceConfig.Type = "oneshot";

      script = ''
        CALENDAR_DIR=${(import ./extra-builtins.nix {}).firstdir "${homedir}/.calendars/"}

        [ -z "$CALENDAR_DIR" ] && exit 1

        ${calcurse-vdirsyncer}/bin/calcurse-vdirsyncer $CALENDAR_DIR
      '';

      path = with pkgs; [
        unstable.calcurse
        vdirsyncer
      ];
    };
  };

  system.userActivationScripts.vdirsyncerSetup = ''
    #!${pkgs.stdenv.shell}

    ${config.system.path}/bin/yes | ${pkgs.vdirsyncer}/bin/vdirsyncer discover
    ${pkgs.vdirsyncer}/bin/vdirsyncer sync
  '';

  home-manager.users.isaac = {
    home.file = {
      ".config/vdirsyncer/config".text =
        let vdirsyncer-getpass-sh = (pkgs.writeShellScriptBin "getpass.sh" ''
          ${pkgs.pass}/bin/pass show vps.myrdd.info/radicale/isaac | ${config.system.path}/bin/head -n1
        ''); in ''
          [general]
          status_path = "~/.vdirsyncer/status/"

          # CARDDAV
          [pair contacts]
          a = "contacts_local"
          b = "contacts_remote"

          collections = ["from a", "from b"]

          # Synchronize the "display name" property into a local file (~/.contacts/displayname).
          metadata = ["displayname"]

          # To resolve a conflict the following values are possible:
          # "null" "a wins" "b wins"
          #conflict_resolution = null

          [storage contacts_local]
          type = "filesystem"
          path = "~/.contacts/"
          fileext = ".vcf"

          [storage contacts_remote]
          type = "carddav"
          url = "${dav-url}"
          username = "isaac"
          password.fetch = ["command", "${vdirsyncer-getpass-sh}/bin/getpass.sh"]

          # CALDAV
          [pair calendar]
          a = "calendar_local"
          b = "calendar_remote"
          collections = ["from a", "from b"]

          # Synchronize the "display name" property into a local file (~/.contacts/displayname).
          metadata = ["displayname", "color"]

          [storage calendar_local]
          type = "filesystem"
          path = "~/.calendars/"
          fileext = ".ics"

          [storage calendar_remote]
          type = "caldav"
          url = "${dav-url}"
          username = "isaac"
          password.fetch = ["command", "${vdirsyncer-getpass-sh}/bin/getpass.sh"]
        '';
    };
  };
}
