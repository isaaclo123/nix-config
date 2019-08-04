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

let calcurse-config = (pkgs.writeText "conf" ''
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
''); in

let calcurse-key-config = (pkgs.writeText "keys" ''
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
''); in

{
  home-manager.users.isaac = {
    home.packages = with pkgs; [
      (calcurse-vdirsyncer)
      unstable.calcurse
      vdirsyncer
      khard
    ];

    home.file = {
      ".calcurse/conf".source = calcurse-config;
      ".calcurse/keys".source = calcurse-key-config;
    };
  };
}
