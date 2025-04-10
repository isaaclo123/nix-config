{ ... }:

let
  create-calcurse-account = {
    name,
    color,
    timer,
    pass,
    caldav-conf,
    only-remote
  }: 
  { pkgs, ... }:
  {
    home.packages = [
      pkgs.calcurse
      (pkgs.writeShellScriptBin "calcurse-${name}" ''
        ${pkgs.calcurse}/bin/calcurse --datadir=$HOME/.calcurse_${name} "$@"
      '')
    ];

    systemd.user = {
      timers."calcurse-caldav-${name}" = {
        Unit = {
          Description = "Run calcurse-caldav for ${name} on a timer";
          X-SwitchMethod = "keep-old";
        };

        Timer = {
          OnCalendar = timer;
          Persistent = true;
        };

        Install = {
          WantedBy = [ "timers.target" ];
        };
      };

      services."calcurse-caldav-${name}" = {
        Unit = {
          Description = "Run calcurse-caldav for ${name}";
          X-SwitchMethod = "keep-old";
        };

        Install = {
          WantedBy = [ "default.target" ];
        };

        Service = {
          Type="oneshot";
          ExecStart = "${pkgs.writeShellScript "run-calcurse-caldav" ''
            DATADIR=$HOME/.calcurse_${name}

            if [ -f $DATADIR/caldav/sync.db ] && [ "${only-remote}" = "false" ]; then
              # if sync db exists dont init
              CALCURSE_CALDAV_PASSWORD=$(${pkgs.pass}/bin/pass show ${pass}) ${pkgs.calcurse}/bin/calcurse-caldav --datadir=$DATADIR --config=$DATADIR/caldav/config --syncdb=$DATADIR/caldav/sync.db --lockfile $DATADIR/.calcurse.pid
            else
              # if sync db does not exist, init
              CALCURSE_CALDAV_PASSWORD=$(${pkgs.pass}/bin/pass show ${pass}) ${pkgs.calcurse}/bin/calcurse-caldav --datadir=$DATADIR --config=$DATADIR/caldav/config --syncdb=$DATADIR/caldav/sync.db --lockfile $DATADIR/.calcurse.pid --init=keep-remote
            fi
          ''}";
        };
      };
    };

    home.file = {
      ".calcurse_${name}/conf".text = ''
        ${builtins.readFile ./conf}

        appearance.theme=${color} on default

        notification.command=calcurse --datadir=$HOME/.calcurse_${name} --next | xargs -0 notify-send -i "${pkgs.rose-pine-icon-theme}/share/icons/rose-pine/32x32/categories/calendar.svg" "Calendar"
      '';

      ".calcurse_${name}/caldav/config".text = ''
        ${builtins.readFile caldav-conf}
      '';
    };
  };
in

{
  imports = [
    (create-calcurse-account {
      name = "personal";
      timer="*:0/30";
      color = "yellow";
      pass = "vps.loisa.ac/radicale";
      caldav-conf = ./caldav.conf;
      only-remote = "false";
    })

    # (create-calcurse-account {
    #   name = "work";
    #   timer="*:2/00";
    #   color = "blue";
    #   pass = "office365.com/isaac.lo@classranked.com";
    #   caldav-conf = ./davmail.config;
    #   only-remote = "true";
    # })
  ];
}
