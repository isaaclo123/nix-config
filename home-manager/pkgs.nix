# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  ...
}: {
  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # (pkgs.discord.override {
    #   # remove any overrides that you don't want
    #   # withOpenASAR = true;
    #   withVencord = false;
    # })
    # discord

    prismlauncher

    p7zip

    wineWowPackages.waylandFull

    pavucontrol
    htop

    solaar

    awscli2
    ssm-session-manager-plugin

    postman
    python311Packages.python-kasa

    audacity
    gimp

    unzip

    ani-cli

    fastfetch
    mangohud

    gnome.cheese
    wget
    killall

    jmtpfs
    cmake
    android-studio

    firefox

    httpie
    http-prompt

    terraform

    wiimms-iso-tools
    android-tools

    jq

    transmission_4-gtk
    unar
    lutris

    zip

    alsa-utils
    gdb

    rust-bindgen
    tinyalsa

    sox
    mediainfo
    lz4

    clang
    mold

    universal-android-debloater
    webcamoid
    ffmpeg

    swayimg

    home-assistant-cli

    hyprpaper

    powertop

    # slack
    # teams-for-linux
  ];
}
