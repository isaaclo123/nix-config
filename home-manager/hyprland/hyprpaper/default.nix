{ pkgs, ...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["/etc/nixos/nixos/stylix/rocket.png"];
      wallpaper = [",/etc/nixos/nixos/stylix/rocket.png"];
    };
  };
}
