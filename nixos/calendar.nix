with import <nixpkgs> {};

let calcurse-vdirsyncer = stdenv.mkDerivation rec {
  name = "calcurse-vdirsyncer";
  src = pkgs.fetchFromGitHub {
    owner = "lfos";
    repo = "calcurse";
    rev = "61d3667899881b8ca17c35b1dbb718c723ecab8e";
    sha256 = "1iw1w5cz1f7p8fc2i89sbbxxmjbxsw8q5jr9r9l1mjlk7kb8v2zd";
    fetchSubmodules = false;
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp ./contrib/vdir/calcurse-vdirsyncer $out/bin/
    chmod +x $out/bin/calcurse-vdirsyncer
  '';
}; in

{ config, pkgs, stdenv, ... }:

let calcurse-config = ''
  appearance.calendarview=monthly
  appearance.compactpanels=no
  appearance.defaultpanel=calendar
  appearance.layout=1
  appearance.notifybar=yes
  appearance.sidebarwidth=0
  appearance.theme=magenta on default
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
  general.autosave=yes
  general.confirmdelete=yes
  general.confirmquit=no
  general.firstdayofweek=monday
  general.periodicsave=2
  general.progressbar=yes
  general.systemdialogs=no
  notification.command=calcurse --next | xargs -0 notify-send "Appointment"
  notification.notifyall=all
  notification.warning=600
''; in

let calcurse-key-config = ''
  generic-cancel  ESC
  generic-select  SPC
  generic-credits  @
  generic-help  ?
  generic-quit  q Q
  generic-save  s S ^S
  generic-reload  R
  generic-copy  c
  generic-paste  p ^V
  generic-change-view  TAB
  generic-import  i I
  generic-export  x X
  generic-goto  g G
  generic-other-cmd  o O
  generic-config-menu  C
  generic-redraw  ^R
  generic-add-appt  ^A
  generic-add-todo  ^T
  generic-prev-day  T ^H
  generic-next-day  t ^L
  generic-prev-week  W ^K
  generic-next-week  w RET
  generic-prev-month  M
  generic-next-month  m
  generic-prev-year  Y
  generic-next-year  y
  generic-scroll-down  ^N
  generic-scroll-up  ^P
  generic-goto-today  ^G
  generic-command  :
  move-right  l L RGT
  move-left  h H LFT
  move-down  j J DWN
  move-up  k K UP
  start-of-week  0
  end-of-week  $
  add-item  a A
  del-item  d D
  edit-item  e E
  view-item  v V
  pipe-item  |
  flag-item  !
  repeat  r
  edit-note  n N
  view-note  >
  raise-priority  +
  lower-priority  -
''; in

let vdirsyncer-getpass-sh = (pkgs.writeShellScriptBin "getpass.sh" ''
  ${pkgs.pass}/bin/pass show vps.myrdd.info/radicale/isaac | head -n1
''); in

let dav-url = "https://vps.myrdd.info/radicale/isaac"; in

let vdirsyncer-config = ''
  # An example configuration for vdirsyncer.
  #
  # Move it to ~/.vdirsyncer/config or ~/.config/vdirsyncer/config and edit it.
  # Run `vdirsyncer --help` for CLI usage.
  #
  # Optional parameters are commented out.
  # This file doesn't document all available parameters, see
  # http://vdirsyncer.pimutils.org/ for the rest of them.

  [general]
  # A folder where vdirsyncer can store some metadata about each pair.
  status_path = "~/.vdirsyncer/status/"

  # CARDDAV
  [pair contacts]
  # A `[pair <name>]` block defines two storages `a` and `b` that should be
  # synchronized. The definition of these storages follows in `[storage <name>]`
  # blocks. This is similar to accounts in OfflineIMAP.
  a = "contacts_local"
  b = "contacts_remote"

  # Synchronize all collections that can be found.
  # You need to run `vdirsyncer discover` if new calendars/addressbooks are added
  # on the server.

  collections = ["from a", "from b"]

  # Synchronize the "display name" property into a local file (~/.contacts/displayname).
  metadata = ["displayname"]

  # To resolve a conflict the following values are possible:
  #   `null` - abort when collisions occur (default)
  #   `"a wins"` - assume a's items to be more up-to-date
  #   `"b wins"` - assume b's items to be more up-to-date
  #conflict_resolution = null

  [storage contacts_local]
  # A storage references actual data on a remote server or on the local disk.
  # Similar to repositories in OfflineIMAP.
  type = "filesystem"
  path = "~/.contacts/"
  fileext = ".vcf"

  [storage contacts_remote]
  type = "carddav"
  url = "${dav-url}"
  username = "isaac"
  # The password can also be fetched from the system password storage, netrc or a
  # custom command. See http://vdirsyncer.pimutils.org/en/stable/keyring.html
  password.fetch = ["command", "${vdirsyncer-getpass-sh}/bin/getpass.sh"]
  verify = "/etc/ssl/certs/ca-certificates.crt"

  # CALDAV
  [pair calendar]
  a = "calendar_local"
  b = "calendar_remote"
  collections = ["from a", "from b"]

  # Calendars also have a color property
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
  verify = "/etc/ssl/certs/ca-certificates.crt"
''; in

{
  environment.systemPackages = with pkgs; [
    (calcurse-vdirsyncer)
    unstable.calcurse
    vdirsyncer
    khard
  ];

  home-manager.users.isaac = {
    home.file = {
      ".calcurse/conf".text = calcurse-config;
      ".calcurse/keys".text = calcurse-key-config;
      ".vdirsyncer/config".text = vdirsyncer-config;
    };
  };
}
