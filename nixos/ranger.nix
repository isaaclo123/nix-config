{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (ranger.override {
      imagePreviewSupport = true;
    })
    imagemagick
    w3m
    ffmpegthumbnailer
    p7zip
    python37Packages.pdf2image
    odt2txt
  ];

  home-manager.users.isaac = {
    # xdg.configFile = {
    #   "ncmpcpp/config".source = ncmpcpp-config;
    #   "ncmpcpp/bindings".source = ncmpcpp-bindings;
    # };
  };
}
