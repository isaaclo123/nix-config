{ pkgs, ... }: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.users.isaac.extraGroups = [ "libvirtd" ];
}
