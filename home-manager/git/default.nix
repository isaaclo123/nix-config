{
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "isaaclo123";
    userEmail = "isaaclo123@gmail.com";
    extraConfig = {
      push.autoSetupRemove = true;
    };
  };

  programs.gh = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes

      Host work
        HostName github.com
        user git
        IdentityFile ~/.ssh/work_rsa
    '';
  };
}
