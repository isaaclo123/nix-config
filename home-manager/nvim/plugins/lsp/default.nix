{ pkgs, ...}: {
  imports = [
    ./nvim-cmp.nix
    ./lsp-saga.nix
    ./luasnip.nix
    ./project-nvim.nix
  ];

  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          nixd.enable = true;

          pyright.enable = true;
          pylsp.enable = true;

          rust-analyzer.enable = true;
          tsserver.enable = true;
        };
        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "g[" = "goto_prev";
            "g]" = "goto_next";
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
