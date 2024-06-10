# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  ...
}: {
  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    (pkgs.discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
    })

    prismlauncher

    pavucontrol
    htop

    awscli2

    audacity
    gimp

    ani-cli

    fastfetch
    mangohud

    gnome.cheese
    wget
    killall

    firefox
  ];
}
