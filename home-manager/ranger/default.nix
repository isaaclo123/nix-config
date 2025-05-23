{ pkgs, ...}: {
  home.packages = with pkgs; [
    ranger
    imagemagick
    elinks
    ffmpegthumbnailer
    odt2txt
    libtar
    file
    calibre
    poppler_utils
    atool
    python311Packages.pillow
  ];

  xdg.configFile = {
    "ranger/plugins/ranger_devicons".source= (pkgs.fetchFromGitHub {
      owner = "alexanderjeurissen";
      repo = "ranger_devicons";
      rev = "1fa1d0f29047979b9ffd541eb330756ac4b348ab";
      sha256 = "0lvcfykhxsjcz2ipxlldasclz459arya4q8b9786kbqp2y1k6z5k";
    });

    "ranger/rifle.conf".text = "${builtins.readFile ./rifle.conf}";
    "ranger/scope.sh" = {
      text = "${builtins.readFile ./scope.sh}";
      executable = true;
    };
    "ranger/rc.conf".text =
    ''
      default_linemode devicons
      set preview_images true
      set preview_images_method kitty
      set preview_script ~/.config/ranger/scope.sh
      set use_preview_script true
      map gn cd /etc/nixos
    '';
  };
}
