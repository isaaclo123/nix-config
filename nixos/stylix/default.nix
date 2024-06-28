{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

    image = pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    };

    fonts = {
      serif = {
        package = pkgs.operator-mono;
        name = "Operator Mono Medium";
      };

      sansSerif = {
        package = pkgs.operator-mono;
        name = "Operator Mono Medium";
      };

      monospace = {
        package = pkgs.operator-mono;
        name = "Operator Mono Medium";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
