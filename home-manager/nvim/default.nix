{ pkgs, ...}: {
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins/direnv.nix
    ./plugins/trouble.nix
    ./plugins/nvim-tree.nix
    ./plugins/surround.nix
    ./plugins/hop.nix
    ./plugins/bufferline.nix
    ./plugins/telescope.nix
    ./plugins/lualine.nix
    ./plugins/tree-sitter.nix
    ./plugins/suda-vim.nix
    ./plugins/lsp/default.nix
    ./plugins/cursorline.nix
    ./plugins/tagbar.nix
    ./plugins/alpha.nix
    ./plugins/indent-blankline.nix
  ];

  home.packages = with pkgs; [wl-clipboard];

  programs.nixvim = {
    enable = true;

    extraPlugins = with pkgs.vimPlugins; [
      auto-pairs
      vim-rooter
    ];
  };
}
