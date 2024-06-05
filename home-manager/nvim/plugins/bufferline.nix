{ pkgs, ...}: {
  programs.nixvim = {
    plugins.bufferline = {
      enable = true;
      sortBy = "insert_at_end";
    };
  };
}
