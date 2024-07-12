{ pkgs, ...}: {
  programs.hyprlock = {
    enable = true;
  };
  services.hypridle = {
    enable = true;
  };
  security.pam.services.hyprlock = {};
}
