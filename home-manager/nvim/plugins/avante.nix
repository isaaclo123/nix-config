{ pkgs, ...}: {
  programs.nixvim = {
    plugins.avante = {
      enable = true;
      settings = {
        provider = "copilot";
        auto_suggestions_provider = "copilot";
        providers = {
          copilot = {
            # model = "claude-sonnet-4.6";
            model = "gpt-5.1";
          };
        };
      };
    };
  };
}
