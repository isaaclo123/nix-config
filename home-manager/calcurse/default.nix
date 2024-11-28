{ pkgs, ... }:

{
  home.packages = with pkgs; [
    calcurse
  ];

  systemd.user = {
    timers.calcurse-caldav = {
      Unit = {
        Description = "Run calcurse-caldav on a timer";
      };

      Timer = {
        OnCalendar = "*:0/30";
        Persistent = true;
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    services.calcurse-caldav = {
      Unit = {
        Description = "Run calcurse-caldav";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = {
        Type="oneshot";
        ExecStart = "${pkgs.writeShellScript "run-calcurse-caldav" ''
          CALCURSE_CALDAV_PASSWORD=$(${pkgs.pass}/bin/pass show vps.loisa.ac/radicale) ${pkgs.calcurse}/bin/calcurse-caldav
        ''}";
      };
    };
  };

  home.file = {
    ".calcurse/conf".text = "${builtins.readFile ./conf}";

    ".calcurse/caldav/config".text = ''
      [General]
      Hostname = vps.loisa.ac
      Path = /radicale/isaac/f2456b9f-371f-bc37-3348-eee973e59b32/
      SyncFilter = cal
      AuthMethod = basic
      InsecureSSL = No
      DryRun = No

      [Auth]
      Username = isaac
    '';
  };
}
