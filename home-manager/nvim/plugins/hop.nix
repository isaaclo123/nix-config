{ pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [hop-nvim];

    keymaps = [
      {
        key = "<Leader>l";
      	action = ":HopWordCurrentLineAC<CR>";
      }
      {
        key = "<Leader>h";
      	action = ":HopWordCurrentLineBC<CR>";
      }
      {
        key = "<Leader>j";
      	action = ":HopVerticalAC<CR>";
      }
      {
        key = "<Leader>k";
      	action = ":HopVerticalBC<CR>";
      }
    ];

    extraConfigLua = ''
      require'hop'.setup()
    '';
  };
}
