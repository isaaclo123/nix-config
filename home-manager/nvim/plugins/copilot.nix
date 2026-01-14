{ pkgs, ...}: {
  programs.nixvim = {
    plugins.copilot-lua = {
      enable = false;
    };
  };
}
