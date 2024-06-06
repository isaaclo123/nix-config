{ config, lib, pkgs, ... }:

let
  notmuch-config = "$.config/notmuch/notmuchrc";
  maildir = ".mail";
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

  passwordCommand = "${pkgs.pass}/bin/pass show ${passPath} | head -n1";

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
      COUNT=$(/bin/find "${maildir}/$ACCOUNTNAME/Inbox/new" -type f | wc -l)

      if [ $COUNT -ge 1 ]; then
        ${pkgs.libnotify}/bin/notify-send \
          "You have $COUNT unread mails"
        # -i icon.path/categories/applications-mail.svg $ACCOUNTNAME \
      fi
    }

    notify "Personal"
    notify "School"
    notify "Work"
  '');
in

{
  home.packages = with pkgs;
    let mail-sync = (writeShellScriptBin "mail-sync" ''
      # ${pkgs.libnotify}/bin/notify-send -i icon.path/categories/applications-mail.svg 'Mail Syncing'
      ${pkgs.isync}/bin/mbsync -a &> /dev/null &&
      ${pkgs.notmuch}/bin/notmuch --config=${notmuch-config} new &> /dev/null
    ''); in [
      (mail-sync)
      # (notify-mail)
    ];
    # ${pkgs.libnotify}/bin/notify-send -i icon.path/categories/applications-mail.svg 'Mail Synced!'
    # ${pkgs.afew}/bin/afew -t -n --notmuch-config=${notmuch-config} &> /dev/null &&

  # home.sessionVariables = {
  #   NOTMUCH_CONFIG = notmuch-config;
  # };


  home.file.".local/oauth2/mutt_oauth2.py" = {
    text = (builtins.readFile ./mutt_oauth2.py);
    executable = true;
  };

  accounts.email = {
    maildirBasePath = maildir;
    accounts = {
      "Personal" = create-account {
        realName = "Isaac Lo";
        userName = "isaaclo123@gmail.com";
        accountName = "Personal";
        # passPath = "google.com/isaaclo123@gmail.com";
        passPath = "gmail-personal-app";
        primary = true;
        imap = gmail-imap;
        smtp = gmail-smtp;
      };

      "School" = create-account {
        realName = "Isaac Lo";
        userName = "loxxx298@umn.edu";
        accountName = "School";
        # passPath = "umn.edu/loxxx298@umn.edu";
        passPath = "gmail-school-app";
        primary = false;
        imap = gmail-imap;
        smtp = gmail-smtp;
      };

      "Work" = lib.mkMerge [(create-account {
        realName = "Isaac Lo";
        userName = "isaac.lo@classranked.com";
        accountName = "Work";
        # passPath = "google.com/isaaclo123@gmail.com";
        passPath = "microsoft-work-pass";
        primary = false;
        imap = {
          host = "outlook.office365.com";
          port = 993;
          tls = {
            enable = true;
            useStartTls = false;
          };
        };
        smtp = {
          host = "smtp-mail.outlook.com";
          port = 587;
          tls = {
            enable = true;
            useStartTls = true;
          };
        };
      })
      {
        passwordCommand = lib.mkForce "$HOME/.local/oauth2/mutt_oauth2.py $HOME/.local/oauth2/work-token";
        mbsync.extraConfig.account = {
          AuthMechs = "XOAUTH2";
        };
      }
      ];
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
          # "${pkgs.libnotify}/bin/notify-send -i icon.path/categories/applications-mail.svg '${accountName}' \"You have $(${config.system.path}/bin/find '${maildir}/${accountName}/Inbox/new' -type f | ${config.system.path}/bin/wc -l) unread mails\"";
      };
      extraConfig = {
        search = {
          exclude_tags = "deleted;spam;";
        };
      };
    };

    mbsync = {
      enable = true;
      package = pkgs.isync.override { withCyrusSaslXoauth2 = true; };
    };

    msmtp = {
      enable = true;
    };
  };
}
