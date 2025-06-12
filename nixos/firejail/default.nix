{ pkgs, ...}: {
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      slack = {
        executable = "${pkgs.slack}/bin/slack";
        profile = "${pkgs.firejail}/etc/firejail/slack.profile";
        desktop = "${pkgs.slack}/share/applications/slack.desktop";
        extraArgs = [
          # Required for U2F USB stick
          # "--ignore=private-dev"
          # "--ignore=caps.keep"
          "--ignore=novideo"
          # Enforce dark mode
          "--env=GTK_THEME=Adwaita:dark"
          # Enable system notifications
          "--dbus-user.talk=org.freedesktop.Notifications"
        ];
      };
      # discord = {
      #   executable = "${pkgs.discord}/bin/discord";
      #   profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      #   desktop = "${pkgs.discord}/share/applications/discord.desktop";
      #   extraArgs = [
      #     # Required for U2F USB stick
      #     # "--ignore=private-dev"
      #     # "--ignore=caps.keep"
      #     "--ignore=novideo"
      #     # Enforce dark mode
      #     "--env=GTK_THEME=Adwaita:dark"
      #     # Enable system notifications
      #     "--dbus-user.talk=org.freedesktop.Notifications"
      #   ];
      # };

      teams-for-linux= {
        executable = "${pkgs.teams-for-linux}/bin/teams-for-linux";
        profile = "${pkgs.firejail}/etc/firejail/teams-for-linux.profile";
        desktop = "${pkgs.teams-for-linux}/share/applications/teams-for-linux.desktop";
        extraArgs = [
          # Required for U2F USB stick
          # "--ignore=private-dev"
          "--ignore=novideo"
          # Enforce dark mode
          "--env=GTK_THEME=Adwaita:dark"
          # Enable system notifications
          "--dbus-user.talk=org.freedesktop.Notifications"
        ];
      };
    };
  };
}
