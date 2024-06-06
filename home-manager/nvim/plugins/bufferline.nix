{ pkgs, ...}: {
  programs.nixvim = {
    plugins.bufferline = {
      enable = true;
      mode = "tabs";
    };
  };
}
