{ pkgs, ...}: {
  services.kdeconnect.enable = true;
  services.kdeconnect.package = pkgs.unstable.plasma5Packages.kdeconnect-kde;
  services.kdeconnect.indicator = true;
}
