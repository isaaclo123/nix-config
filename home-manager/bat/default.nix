{ pkgs, ...}: {
  programs.bat = {
    enable = true;
    config = {
      italic-text="always";
      # theme="base16";
    };
  };
}
