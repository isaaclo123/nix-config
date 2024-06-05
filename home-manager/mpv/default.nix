{ pkgs, ...}: {
  imports = [
    ./config.nix
    ./bindings.nix
    ./profiles.nix
    ./script-opts.nix
  ];
  programs.mpv = {
    enable = true;

    scripts = with pkgs.mpvScripts; [
      uosc
      sponsorblock
      thumbfast
      quality-menu
      mpris
    ];
  };
}
