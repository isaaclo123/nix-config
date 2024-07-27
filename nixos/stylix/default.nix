{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

    image = ./rocket.png;

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
