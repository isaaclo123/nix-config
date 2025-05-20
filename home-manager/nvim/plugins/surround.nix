{ pkgs, ...}: {
  programs.nixvim = {
    plugins.vim-surround = {
      enable = true;
    };
  };
}
