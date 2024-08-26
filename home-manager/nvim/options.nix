{ pkgs, ...}: {
  programs.nixvim = {
    # colorschemes.base16.enable = true;
    # colorschemes.base16.colorscheme = "rose-pine";

    opts = {
	    # syn = "sync fromstart";
	    encoding = "utf-8";
	    number = true;
	    cursorline = true;
	    hlsearch = true;
	    incsearch = true;
	    ic = true;
	    smartcase = true;
	    smartindent = true;
	    lazyredraw = true;
	    ttyfast = true;
	    mouse = "a";
	    clipboard = "unnamedplus";
	    so = 999;

	    splitright = true;

	    tabstop = 2;
	    softtabstop = 0;
	    expandtab = true;
	    shiftwidth = 2;
	    smarttab = true;
	    colorcolumn = "100";
      # "&t_ut" = 0; # kitty option
      termguicolors = true;
    };
  };
}
