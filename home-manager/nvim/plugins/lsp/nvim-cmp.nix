# https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/
# https://github.com/GaetanLepage/nix-config/blob/be80632010fab858b46fb7b461ee0b3cd6ec4b97/home/modules/tui/neovim/completion.nix
{ pkgs, ...}: {
  programs.nixvim = {
    opts = {
      updatetime = 250;
      completeopt = ["menu" "menuone" "noselect"];
    };

    extraConfigLua = ''
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = false,
        float = true,
      })

      local sign = function(opts)
        vim.fn.sign_define(opts.name, {
          texthl = opts.name,
          text = opts.text,
          numhl = ""
        })
      end

      sign({name = 'DiagnosticSignError', text = '✘'})
      sign({name = 'DiagnosticSignWarn', text = '▲'})
      sign({name = 'DiagnosticSignHint', text = '⚑'})
      sign({name = 'DiagnosticSignInfo', text = '»'})
    '';

    autoCmd = [
      {
        event = ["CursorHold" "CursorHoldI"];
        pattern = "*";
        command = "lua vim.diagnostic.open_float(nil, {focus=false})";
      }
    ];

    plugins = {
      luasnip.enable = true;

      lspkind = {
        enable = true;
        mode = "symbol_text";

        cmp = {
          enable = true;

          menu = {
            nvim_lsp = "[LSP]";
            nvim_lua = "[api]";
            path = "[path]";
            luasnip = "[snip]";
            buffer = "[buffer]";
          };
        };
      };

      cmp = {
        enable = true;
        settings = {
          sources = [
            {name = "path";}
            {name = "copilot";}
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {
              name = "buffer";
              # Words from other open buffers can also be suggested.
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
          ];
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };
      };
    };
  };
}
