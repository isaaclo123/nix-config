{ config, lib, pkgs, ... }:

let
  homedir = (import ./settings.nix).homedir;
  username = (import ./settings.nix).username;
  icon = (import ./settings.nix).icon;
in

let notmuch-config = "${homedir}/.config/notmuch/notmuchrc"; in

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
        "${pkgs.libnotify}/bin/notify-send -i ${icon.path}/categories/applications-mail.svg '${accountName}' 'New Mail!'";
    };
  };

  passwordCommand = "${pkgs.pass}/bin/pass show ${passPath} | ${config.system.path}/bin/head -n1";

  mbsync = {
    enable = true;
    create = "both";
    expunge = "both";
    patterns = [
      "archive"
      "Inbox"
      "Sent"
      "Trash"
      "[Gmail]/Drafts"
      "[Gmail]/Sent Mail"
      "[Gmail]/Starred"
      "[Gmail]/All Mail"
    ];
  };

  notmuch.enable = true;
  msmtp.enable = true;
}; in

{
  environment.systemPackages = with pkgs;
    let mail-sync= (writeShellScriptBin "mail-sync" ''
      notify-send "Mail Syncing"
      mbsync -a &> /dev/null
    ''); in [
      (mail-sync)
    ];

  environment.variables = {
    NOTMUCH_CONFIG = notmuch-config;
  };

  home-manager.users."${username}" = {
    accounts.email = {
      maildirBasePath = "${homedir}/.mail";
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
      # mbsync = {
      #   enable = true;
      #   frequency = "*:0/30";
      #   # postExec = "${pkgs.notmuch}/bin/notmuch --config=${notmuch-config} new;${pkgs.afew}/bin/afew -t -n";
      # };
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
