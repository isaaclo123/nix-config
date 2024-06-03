{ pkgs, ...}: {
  programs.nixvim = {
    plugins.cursorline = {
      enable = true;
    };
  };
}
