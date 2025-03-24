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
      diff.tool = "nvimdiff";
      difftool.prompt = "false";
      difftool.nvimdiff.cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
      merge.tool = "nvimdiff";
      mergetool.prompt = true;
      mergetool.nvimdiff.cmd = "nvim -d \"$LOCAL\" \"$REMOTE\" \"$MERGED\" -c 'wincmd w' -c 'wincmd J'";
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
