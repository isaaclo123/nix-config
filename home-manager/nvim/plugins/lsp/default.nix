{ pkgs, ...}: {
  imports = [
    ./nvim-cmp.nix
    ./lsp-saga.nix
    ./luasnip.nix
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
        keymaps.lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          # "gt" = "type_definition";
          # "gd" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
        };
      };
      # lsp-lines = {
      #   enable = true;
      #   currentLine = false;
      # };
      rust-tools.enable = true;

      lspkind = {
        enable = true;
        cmp.enable = true;
      };
    };
  };
}
