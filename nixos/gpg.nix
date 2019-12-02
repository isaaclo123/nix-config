{ pkgs, ... }:

let username = (import ./settings.nix).username; in

# monkeysphere g to generate ssh key
# monkeysphere s to add ssh key

{
  environment.systemPackages = with pkgs; [
    gnupg
    monkeysphere
  ];

  environment.shellInit = ''
    if [ "$EUID" -ne 0 ]; then
      # if not root
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      echo UPDATESTARTUPTTY | gpg-connect-agent &> /dev/null
    fi
  '';

  home-manager.users."${username}" = {
    services = {
      gpg-agent = {
        enable = true;

        defaultCacheTtl = 2147483647;
        maxCacheTtl = 2147483647;

        defaultCacheTtlSsh = 2147483647;
        maxCacheTtlSsh = 2147483647;

        enableSshSupport = true;
        # extraConfig = ''
        #   pinentry-program ${pkgs.pinentry}/bin/pinentry_gnome
        # '';
      };
    };
  };
}
