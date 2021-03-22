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

let
  gmail-imap = {
    host = "imap.gmail.com";
    port = 993;
    tls = {
      enable = true;
      useStartTls = false;
    };
  };

  gmail-smtp = {
    host = "smtp.gmail.com";
    port = 587;
    tls = {
      enable = true;
      useStartTls = true;
    };
  };

  # microsoft-imap = {
  #   host = "outlook.office365.com";
  #   port = 993;
  #   tls = {
  #     enable = true;
  #     # useStartTls = true;
  #   };
  # };

  # microsoft-smtp = {
  #   host = "smtp.office365.com";
  #   port = 587;
  #   tls = {
  #     enable = true;
  #     useStartTls = true;
  #   };
  # };
in

let create-account = {
  realName,
  userName,
  accountName,
  passPath,
  primary,
  imap,
  smtp
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

  imap = imap;
  smtp = smtp;

  # imapnotify = {
  #   enable = true;
  #   boxes = [ "Inbox" ];
  #   onNotify = "${pkgs.isync}/bin/mbsync ${accountName}";
  #   onNotifyPost = {
  #     mail =
  #       "${pkgs.notmuch}/bin/notmuch --config=${notmuch-config} new && " +
  #       "${pkgs.afew}/bin/afew -t -n --notmuch-config=${notmuch-config} && " +
  #       "${pkgs.libnotify}/bin/notify-send -i ${icon.path}/categories/applications-mail.svg '${accountName}' \"You have $(${config.system.path}/bin/find '${maildir}/${accountName}/Inbox/new' -type f | ${config.system.path}/bin/wc -l) unread mails\"";
  #   };
  # };

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


let
  notify-mail = (pkgs.writeShellScriptBin "notify-mail" ''
    notify () {
      ACCOUNTNAME=$1

      ${pkgs.libnotify}/bin/notify-send \
        -i ${icon.path}/categories/applications-mail.svg $ACCOUNTNAME \
        "You have $(${config.system.path}/bin/find "${maildir}/$ACCOUNTNAME/Inbox/new" -type f | ${config.system.path}/bin/wc -l) unread mails"
    }

    notify "Personal"
    notify "School"
  '');
in

{
  environment.systemPackages = with pkgs;
    let mail-sync = (writeShellScriptBin "mail-sync" ''
      ${pkgs.libnotify}/bin/notify-send -i ${icon.path}/categories/applications-mail.svg 'Mail Syncing'
      ${pkgs.isync}/bin/mbsync -a &> /dev/null &&
      ${pkgs.notmuch}/bin/notmuch --config=${notmuch-config} new &> /dev/null
    ''); in [
      (mail-sync)
      # (notify-mail)
    ];
    # ${pkgs.libnotify}/bin/notify-send -i ${icon.path}/categories/applications-mail.svg 'Mail Synced!'
    # ${pkgs.afew}/bin/afew -t -n --notmuch-config=${notmuch-config} &> /dev/null &&

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
          imap = gmail-imap;
          smtp = gmail-smtp;
        };

        "School" = create-account {
          realName = "Isaac Lo";
          userName = "loxxx298@umn.edu";
          accountName = "School";
          passPath = "umn.edu/loxxx298@umn.edu";
          primary = false;
          imap = gmail-imap;
          smtp = gmail-smtp;
        };
      };
    };

    services = {
      # imapnotify.enable = true;

      mbsync = {
        enable = true;
        frequency = "hourly";
        postExec = "${pkgs.notmuch}/bin/notmuch --config=${notmuch-config} new";
          # "&& ${config.system.path}/bin/systemctl restart --user \"imapnotify-*.service\"";
      };
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
        hooks = {
          postNew = "${pkgs.afew}/bin/afew -t -n --notmuch-config=${notmuch-config}; ${notify-mail}/bin/notify-mail";# +
            # "${pkgs.libnotify}/bin/notify-send -i ${icon.path}/categories/applications-mail.svg '${accountName}' \"You have $(${config.system.path}/bin/find '${maildir}/${accountName}/Inbox/new' -type f | ${config.system.path}/bin/wc -l) unread mails\"";
        };
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
