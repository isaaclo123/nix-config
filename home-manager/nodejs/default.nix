{ pkgs, ...}: {
  programs.fish.interactiveShellInit = ''
    npm set prefix ~/.npm-global
  '';

  home.packages = with pkgs; [
    nodejs
  ];
}
