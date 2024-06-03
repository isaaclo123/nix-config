{ pkgs, ...}: {
  programs.nixvim = {
    plugins.nvim-tree = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<Leader>n";
        action = ":NvimTreeToggle<CR>";
        options.noremap = true;
      }
    ];
  };
}
