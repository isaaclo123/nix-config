{ pkgs, ... }:

let
  homedir = (import ./settings.nix).homedir;
  username = (import ./settings.nix).username;
in

let notmuch-config = "${homedir}/.config/notmuch/notmuchrc"; in

{
  environment.systemPackages = with pkgs;
    let mail-sync= (writeShellScriptBin "mail-sync" ''
      notify-send "Mail Syncing"
      mbsync -a &> /dev/null
      notmuch --config=${notmuch-config} new &> /dev/null
      notify-send "Mail Sync Done!"
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
        "Personal" = {
          primary = true;
          realName = "Isaac Lo";
          address = "isaaclo123@gmail.com";
          userName = "isaaclo123@gmail.com";
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

          passwordCommand = "${pkgs.pass}/bin/pass show google.com/isaaclo123@gmail.com | head -n1";

          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
          };

          notmuch.enable = true;
          msmtp.enable = true;
        };

        "School" = {
          primary = false;
          realName = "Isaac Lo";
          address = "loxxx298@umn.edu";
          userName = "loxxx298@umn.edu";
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

          # signature = {
          #   text = ''
          #     --

          #     Isaac Lo

          #     220 Delaware Street
          #     Minneapolis, MN 55455
          #     1(650)-503-1253
          #   '';
          #   showSignature = "append";
          # };

          passwordCommand = "${pkgs.pass}/bin/pass show umn.edu/loxxx298@umn.edu | head -n1";

          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
          };

          notmuch.enable = true;
          msmtp.enable = true;
        };
      };
    };

    services = {
      mbsync = {
        enable = true;
        frequency = "*:0/30";
        postExec = "${pkgs.notmuch}/bin/notmuch --config=${notmuch-config} new";
      };
    };

    programs = {
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
