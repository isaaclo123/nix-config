{ pkgs, ...}: {
  programs.nixvim = {
    plugins.lspsaga = {
      enable = true;
    };

    extraConfigLua = ''
      local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticsSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    '';
  };
}
