{ pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-suda
    ];

    globals = {
      "suda#noninteractive" = 1;
      "suda_smart_edit" = 1;
    };
  };
}
