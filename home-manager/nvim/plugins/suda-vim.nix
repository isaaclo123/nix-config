{ pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      suda-vim
    ];

    globals = {
      "suda#noninteractive" = 1;
      "suda_smart_edit" = 1;
    };
  };
}
