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
        (pkgs.writeText "calcurse-vdirsyncer.patch" ''
          --- a/contrib/vdir/calcurse-vdirsyncer	2019-08-30 11:33:23.860473150 -0500
          +++ b/contrib/vdir/calcurse-vdirsyncer	2019-08-30 11:36:45.910492110 -0500
          @@ -66,6 +66,20 @@
              esac
           done

          -calcurse-vdir export "$VDIR" -D "$DATADIR" "$FORCE" "$VERBOSE" && \
          -	vdirsyncer sync && \
          -	calcurse-vdir import "$VDIR" -D "$DATADIR" "$FORCE" "$VERBOSE"
          +if [[ ! -z "$VERBOSE" ]] && [[ ! -z "$FORCE" ]]; then
          +  calcurse-vdir export "$VDIR" -D "$DATADIR" "$FORCE" "$VERBOSE" && \
          +    vdirsyncer sync && \
          +    calcurse-vdir import "$VDIR" -D "$DATADIR" "$FORCE" "$VERBOSE"
          +elif [[ ! -z "$VERBOSE" ]]; then
          +  calcurse-vdir export "$VDIR" -D "$DATADIR" "$VERBOSE" && \
          +    vdirsyncer sync && \
          +    calcurse-vdir import "$VDIR" -D "$DATADIR" "$VERBOSE"
          +elif [[ ! -z "$FORCE" ]]; then
          +  calcurse-vdir export "$VDIR" -D "$DATADIR" "$FORCE" && \
          +    vdirsyncer sync && \
          +    calcurse-vdir import "$VDIR" -D "$DATADIR" "$FORCE"
          +else
          +  calcurse-vdir export "$VDIR" -D "$DATADIR" && \
          +    vdirsyncer sync && \
          +    calcurse-vdir import "$VDIR" -D "$DATADIR"
          +fi
        '')
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

      wantedBy = [ "nixos-activation.service" ];
      after = [ "nixos-activation.service" ];

      serviceConfig.Type = "oneshot";

      script = ''
        CALENDAR_DIR=$(ls -d ${homedir}/.calendars/* | head -n1)

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
    ${pkgs.vdirsyncer}/bin/vdirsyncer discover
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
