{ pkgs, ... }:

# monkeysphere g to generate ssh key
# monkeysphere s to add ssh key

{
  home.packages = with pkgs; [
    gnupg
    monkeysphere
  ];

  services = {
    gpg-agent = {
      enable = true;

      defaultCacheTtl = 2147483647;
      maxCacheTtl = 2147483647;

      defaultCacheTtlSsh = 2147483647;
      maxCacheTtlSsh = 2147483647;

      enableSshSupport = true;
    };
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };
    unclutter = {
      enable = true;
    };
  };
}
