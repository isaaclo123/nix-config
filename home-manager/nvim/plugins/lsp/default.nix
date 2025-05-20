{ pkgs, ...}: {
  imports = [
    ./nvim-cmp.nix
    ./lsp-saga.nix
    ./luasnip.nix
    ./project-nvim.nix
  ];

  programs.nixvim = {

    plugins = {
      conform-nvim = {
        enable = true;
        settings.formatters_by_ft = {
          python = [ "isort" "black" ];
          typescript = [ "eslintd" ];
          javascript = [ "eslintd" ];
        };
        settings.format_on_save = {
          lspFallback = false;
          timeoutMs = 500;
        };
      };

      lsp-format = {
        enable = true;
        lspServersToEnable = [
          "pylsp"
          "pyright"
          "rust_analyzer"
          "eslint"
        ];
      };

      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          nixd.enable = true;

          pyright.enable = true;
          pylsp.enable = true;

          rust_analyzer.enable = true;
          eslint.enable = true;
          ts_ls.enable = true;
        };
        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "d[" = "goto_prev";
            "d]" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gI = "type_definition";
            gi = "implementation";
            K = "hover";
            "<F2>" = "rename";
          };
        };
      };
      # lsp-lines = {
      #   enable = true;
      #   currentLine = false;
      # };
      rust-tools.enable = true;
    };
  };
}
