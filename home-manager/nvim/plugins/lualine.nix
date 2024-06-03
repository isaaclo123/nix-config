{ pkgs, ...}: {
  programs.nixvim = {
    plugins.lualine = {
      enable = true;
      iconsEnabled = true;
      theme = "base16";
    };
  };
}
