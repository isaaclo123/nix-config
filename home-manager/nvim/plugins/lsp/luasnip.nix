{ pkgs, ...}: {
  programs.nixvim = {
    plugins.cmp_luasnip.enable = true;

    plugins.luasnip = {
      enable = true;

      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
    };
  };
}
