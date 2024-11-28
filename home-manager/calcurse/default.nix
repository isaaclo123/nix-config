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
    ".calcurse/conf".text = ''
      appearance.calendarview=monthly
      appearance.compactpanels=no
      appearance.defaultpanel=calendar
      appearance.layout=1
      appearance.notifybar=yes
      appearance.sidebarwidth=0
      appearance.theme=yellow on default
      appearance.todoview=show-completed
      appearance.headingpos=right-justified
      daemon.enable=yes
      daemon.log=no
      format.inputdate=1
      format.notifydate=%a %F
      format.notifytime=%T
      format.outputdate=%D
      format.dayheading=%B %-d, %Y
      general.autogc=yes
      general.autosave=no
      general.confirmdelete=yes
      general.confirmquit=no
      general.firstdayofweek=monday
      general.periodicsave=0
      general.progressbar=yes
      general.systemdialogs=no
      notification.command=calcurse --next | xargs -0 notify-send "Calendar"
      notification.notifyall=all
      notification.warning=900
    '';

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
