# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    inputs.nixvim.homeManagerModules.nixvim

    ./bat/default.nix
    ./nvim/default.nix
    ./hyprland/default.nix
    ./kitty/default.nix
    ./qutebrowser/default.nix
    ./chromium/default.nix
    ./fish/default.nix
    ./ranger/default.nix
    ./password-store/default.nix
    ./rust/default.nix
    ./kdeconnect/default.nix
    ./gpg/default.nix
    ./nodejs/default.nix
    ./mpv/default.nix
    ./dunst/default.nix
    ./python/default.nix
    ./udiskie/default.nix
    ./gammastep/default.nix
    ./email/default.nix
    ./git/default.nix
    ./zathura/default.nix
    ./calcurse/default.nix
    ./khard/default.nix
    ./pkgs.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      # outputs.overlays.unstable-packages
      inputs.rust-overlay.overlays.default

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "isaac";
    homeDirectory = "/home/isaac";
  };

  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform --ozone-platform=wayland
  '';

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.nix-index =
  {
    enable = true;
    enableFishIntegration = true;
  };

  services.syncthing = {
    enable = true;
  };

  gtk.iconTheme = {
    package = pkgs.rose-pine-icon-theme;
    name = "rose-pine-icon-theme";
  };

  # stylix.targets.regreet.enable = false;
  stylix.targets.fish.enable = false;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
