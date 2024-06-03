{ pkgs, ...}: {
  programs.nixvim = {
    plugins.tagbar = {
      enable = true;
      extraConfig = {};
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
