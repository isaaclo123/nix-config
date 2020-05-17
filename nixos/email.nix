{ config, lib, pkgs, ... }:

let
  homedir = (import ./settings.nix).homedir;
  username = (import ./settings.nix).username;
  icon = (import ./settings.nix).icon;
in

let
  notmuch-config = "${homedir}/.config/notmuch/notmuchrc";
  maildir = "${homedir}/.mail";
in

let mail-notify = pkgs.writeShellScript "mail-notify.sh" ''
  # count new mail for every maildir
  newfolder="$2"
  new="$(find $newfolder -type f | wc -l)"

  if [ $new -gt 0 ]
  then
    ${pkgs.libnotify}/bin/notify-send -i ${icon.path}/categories/applications-mail.svg "$1" "You have $new unread emails"
  fi
''; in

let create-account = {
  realName,
  userName,
  accountName,
  passPath,
  primary
}: {
  primary = primary;
  realName = realName;
  address = userName;
  userName = userName;

  folders = {
    inbox = "Inbox";
    sent = "Sent";
    trash = "Trash";
    drafts = "Drafts";
  };

  imap = {
    host = "imap.gmail.com";
    port = 993;
    tls = {
      enable = true;
      # useStartTls = true;
    };
  };
  smtp = {
    host = "smtp.gmail.com";
    port = 587;
    tls = {
      enable = true;
      useStartTls = true;
    };
  };

  imapnotify = {
    enable = true;
    boxes = [ "Inbox" ];
    onNotify = "${pkgs.isync}/bin/mbsync ${accountName}";
    onNotifyPost = {
      mail =
        "${pkgs.notmuch}/bin/notmuch --config=${notmuch-config} new && " +
        "${pkgs.afew}/bin/afew -t -n --notmuch-config=${notmuch-config} && " +
        "${mail-notify} '${accountName}' '${maildir}/${accountName}/Inbox/new'";
    };
  };

  passwordCommand = "${pkgs.pass}/bin/pass show ${passPath} | ${config.system.path}/bin/head -n1";

  mbsync = {
    enable = true;
    create = "both";
    expunge = "both";
    patterns = [
      "*"
      "!Travel"
    ];
  };

  notmuch.enable = true;
  msmtp.enable = true;
}; in

{
  environment.systemPackages = with pkgs;
    let mail-sync= (writeShellScriptBin "mail-sync" ''
      ${pkgs.libnotify}/bin/notify-send -i ${icon.path}/categories/applications-mail.svg 'Mail Syncing'
      ${pkgs.isync}/bin/mbsync -a &> /dev/null &&
      ${pkgs.notmuch}/bin/notmuch --config=${notmuch-config} new &> /dev/null &&
      ${pkgs.afew}/bin/afew -t -n --notmuch-config=${notmuch-config} &> /dev/null &&
      ${pkgs.libnotify}/bin/notify-send -i ${icon.path}/categories/applications-mail.svg 'Mail Synced!'
    ''); in [
      (mail-sync)
    ];

  environment.variables = {
    NOTMUCH_CONFIG = notmuch-config;
  };

  home-manager.users."${username}" = {
    accounts.email = {
      maildirBasePath = maildir;
      accounts = {
        "Personal" = create-account {
          realName = "Isaac Lo";
          userName = "isaaclo123@gmail.com";
          accountName = "Personal";
          passPath = "google.com/isaaclo123@gmail.com";
          primary = true;
        };

        "School" = create-account {
          realName = "Isaac Lo";
          userName = "loxxx298@umn.edu";
          accountName = "School";
          passPath = "umn.edu/loxxx298@umn.edu";
          primary = false;
        };
      };
    };

    services = {
      imapnotify.enable = true;
    };

    programs = {
      afew = {
        enable = true;
        extraConfig = ''
          [SpamFilter]
          [KillThreadsFilter]
          [ArchiveSentMailsFilter]
          [InboxFilter]
        '';
      };

      notmuch = {
        enable = true;
        new.tags = [ "new" "unread" ];
        hooks = {};
        extraConfig = {
          search = {
            exclude_tags = "deleted;spam;";
          };
        };
      };

      mbsync = {
        enable = true;
      };

      msmtp = {
        enable = true;
      };
    };
  };
}
