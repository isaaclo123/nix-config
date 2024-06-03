{ pkgs, ...}: {
  programs.nixvim = {
    options = {
      updatetime = 250;
    };

    extraConfigLua = ''
      vim.diagnostic.config({
        virtual_text = false
      })
    '';

    autoCmd = [
      {
        event = ["CursorHold" "CursorHoldI"];
        pattern = "*";
        command = "lua vim.diagnostic.open_float(nil, {focus=false})";
      }
    ];

    plugins.nvim-cmp = {
      enable = true;
      autoEnableSources = true;

      snippet.expand = "luasnip";

      mapping = {
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<CR>" = "cmp.mapping.confirm({ select = true })"; # Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

      };
    };
  };
}
