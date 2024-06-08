{ pkgs, ...}: {
  programs.fish.interactiveShellInit = ''
    set -e SSH_AUTH_SOCK
    set -U -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    set -x GPG_TTY (tty)

    gpgconf --launch gpg-agent
  '';

  # monkeysphere g for creating gpg key
  # monkeysphere s for ssh key
  home.packages = with pkgs; [ monkeysphere ];

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;

    pinentryPackage = pkgs.pinentry-gtk2;

    defaultCacheTtl = 2147483647;
    maxCacheTtl = 2147483647;

    defaultCacheTtlSsh = 2147483647;
    maxCacheTtlSsh = 2147483647;

    enableSshSupport = true;
  };
}
