{ pkgs, ...}: {
  programs.nixvim = {
    plugins.tagbar = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<F8>";
        action = ":TagbarToggle<CR>";
        options.noremap = true;
      }
    ];

  };

}
