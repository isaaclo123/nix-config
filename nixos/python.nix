{ pkgs, ... }:

with pkgs;
let my-python-packages = python-packages: with python-packages; [
    conda
    # other python packages you want
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
in
{
  home-manager.users.isaac = {
    home.packages = with pkgs; [
      python-with-my-packages
    ];
  };
}
