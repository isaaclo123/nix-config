{ pkgs, ...}: {
  programs.nixvim = {
    globals.mapleader = " ";

    keymaps = [
      {
        mode = "i";
        key = "jk";
        action = "<Esc>";
        options.noremap = true;
      }
      {
        key = "<CR><CR>";
        action = "<Esc>:nohlsearch<CR><Esc>";
        options.silent = true;
        options.noremap = true;
      }
      {
        key = "<Leader><Leader>";
        action = "V";
        options.silent = true;
        options.noremap = true;
      }
      {
        key = "<Leader>w";
        action = ":update<CR>";
        options.noremap = true;
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w><right>";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w><down>";
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w><left>";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><up>";
      }
    ];
  };
}
