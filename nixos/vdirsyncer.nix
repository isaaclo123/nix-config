{ config, lib, pkgs, ... }:

let
  homedir = (import ./settings.nix).homedir;
  username = (import ./settings.nix).username;
  dav-url= (import ./settings.nix).dav-url;
in

{
  environment.systemPackages = with pkgs; [
    # (calcurse-vdirsyncer)
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

      # ${calcurse-vdirsyncer}/bin/calcurse-vdirsyncer $CALENDAR_DIR

      script = ''
        CALENDAR_DIR=${(import ./extra-builtins.nix {}).firstdir "${homedir}/.calendars/"}

        [ -z "$CALENDAR_DIR" ] && exit 1

        # test if server reachable
        ${pkgs.curl}/bin/curl -m 3 -s -o /dev/null -w "%{http_code}" ${dav-url} | grep 403 || exit 1

        ${pkgs.unstable.calcurse}/bin/calcurse-vdir export $CALENDAR_DIR -D "${homedir}/.calcurse" &&
        ${pkgs.vdirsyncer}/bin/vdirsyncer sync &&
        ${pkgs.unstable.calcurse}/bin/calcurse-vdir import $CALENDAR_DIR -D "${homedir}/.calcurse"
      '';

      path = with pkgs; [
        unstable.calcurse
        vdirsyncer
      ];
    };
  };

  system.userActivationScripts.vdirsyncerSetup = {
    text = ''
      # test if server reachable
      ${pkgs.curl}/bin/curl -m 3 -s -o /dev/null -w "%{http_code}" ${dav-url} | grep -e "404" -e "000" && exit 1

      ${config.system.path}/bin/yes | ${pkgs.vdirsyncer}/bin/vdirsyncer discover
      ${pkgs.vdirsyncer}/bin/vdirsyncer sync
    '';

    deps = [ ];
  };

  home-manager.users."${username}" = {
    home.file = {
      ".config/vdirsyncer/config".text =
        let vdirsyncer-getpass-sh = (pkgs.writeShellScriptBin "getpass.sh" ''
          ${pkgs.pass}/bin/pass show vps.isaaclo.site/radicale/isaac | ${config.system.path}/bin/head -n1
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
