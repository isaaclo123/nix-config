{ pkgs, ...}: {
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      nixvimInjections = true;

      settings = {
        auto_install = true;
        highlight.enable = true;
      };
    };
  };
}
