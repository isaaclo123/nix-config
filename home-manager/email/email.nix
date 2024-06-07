{ config, lib, pkgs, ... }:

let
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
in

let
  mbsync-pkg = pkgs.isync.override { withCyrusSaslXoauth2 = true; };

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

  mail-sync = (pkgs.writeShellScriptBin "mail-sync" ''
    ${mbsync-pkg}/bin/mbsync -a
    ${pkgs.notmuch}/bin/notmuch new
  '');
in

let create-account = {
  realName,
  userName,
  accountName,
  primary,
  imap,
  smtp
}: 
let
  passScript = pkgs.writeShellScriptBin "pass-script.sh" ''
    export PATH=$PATH:${pkgs.gnupg}/bin
    ${pkgs.python3}/bin/python ${config.home.homeDirectory}/.local/share/oauth2/mutt_oauth2.py ${config.home.homeDirectory}/.local/share/oauth2/${accountName}-token
  '';
in
{
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

  imapnotify = {
    enable = true;
    boxes = [ "Inbox" ];
    onNotify = "${mbsync-pkg}/bin/mbsync ${accountName}";
    onNotifyPost = "${pkgs.notmuch}/bin/notmuch new";
    extraConfig = {
      xoauth2 = true;
      extraConfig = {
        tlsOptions = {
          rejectUnauthorized = true;
          starttls = true;
        };
      };
    };
  };

  # passwordCommand = "${pkgs.python3}/bin/python ${config.home.homeDirectory}/.local/share/oauth2/mutt_oauth2.py ${config.home.homeDirectory}/.local/share/oauth2/${accountName}-token'";
  passwordCommand = "${pkgs.runtimeShell} ${passScript}/bin/pass-script.sh";
  # passwordCommand = "cat /home/isaac/personaltoken";

  mbsync = {
    enable = true;
    create = "both";
    expunge = "both";
    patterns = [
      "*"
      "!Travel"
    ];
    extraConfig.account = {
      AuthMechs = "XOAUTH2";
    };
  };

  notmuch.enable = true;

  msmtp = {
    enable = true;
    extraConfig = {
      auth = "oauthbearer";
    };
  };
};
in

{
  home.packages = with pkgs;
    [
      (mail-sync)
      (notify-mail)
    ];
    # ${pkgs.libnotify}/bin/notify-send -i icon.path/categories/applications-mail.svg 'Mail Synced!'
    # ${pkgs.afew}/bin/afew -t -n --notmuch-config=${notmuch-config} &> /dev/null &&

  # home.sessionVariables = {
  #   NOTMUCH_CONFIG = notmuch-config;
  # };


  home.file.".local/share/oauth2/mutt_oauth2.py" = {
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
        primary = true;
        imap = gmail-imap;
        smtp = gmail-smtp;
      };

      "School" = create-account {
        realName = "Isaac Lo";
        userName = "loxxx298@umn.edu";
        accountName = "School";
        primary = false;
        imap = gmail-imap;
        smtp = gmail-smtp;
      };

      "Work" = create-account {
        realName = "Isaac Lo";
        userName = "isaac.lo@classranked.com";
        accountName = "Work";
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
      };
    };
  };

  services = {
    mbsync = {
      enable = true;
      frequency = "hourly";
      postExec = "${pkgs.notmuch}/bin/notmuch new";
        # "&& ${config.system.path}/bin/systemctl restart --user \"imapnotify-*.service\"";
    };
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
      hooks = {
        postNew = "${pkgs.afew}/bin/afew -t ${notify-mail}/bin/notify-mail";
      };
      extraConfig = {
        search = {
          exclude_tags = "deleted;spam;";
        };
      };
    };

    mbsync = {
      enable = true;
      package = mbsync-pkg;
    };

    msmtp = {
      enable = true;
    };
  };
}
