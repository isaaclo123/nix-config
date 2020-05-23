{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  icon = (import ./settings.nix).icon;
in

{
  environment.systemPackages = with pkgs; [
    unstable.calcurse
  ];

  home-manager.users."${username}" = {
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
        notification.command=calcurse --next | xargs -0 notify-send -i "${icon.path}/places/calendar-$(date +'%d').svg" "Calendar"
        notification.notifyall=all
        notification.warning=600
      '';

      ".calcurse/keys".text = ''
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
      '';
    };
  };
}
