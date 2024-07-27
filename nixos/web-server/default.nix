{ pkgs, ... }: {
  services.static-web-server = {
    enable = true;
    root = "/var/www";
  };
  networking.firewall.allowedTCPPorts = [ 8787 ];
  systemd.tmpfiles.rules = [
    "d /var/www 0755 isaac isaac"
  ];
}
