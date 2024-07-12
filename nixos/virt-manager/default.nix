{ pkgs, ... }: {
  programs.adb.enable = true;
  users.users.isaac.extraGroups = ["adbusers"];
}
