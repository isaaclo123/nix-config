{ pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
    settings = {
      "plugin" = ["opencode-notify" "op-anthropic-auth@latest"];
      tui = {
        "theme" = "rosepine";
      };
    };
  };
}
