{ pkgs, ...}: {
  programs.nixvim = {
    plugins.surround = {
      enable = true;
    };
  };
}
