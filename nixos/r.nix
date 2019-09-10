{ pkgs, ... }:

let
  R-with-my-packages =
    with pkgs;
      rWrapper.override {
      packages = with rPackages; [
        dice
        ggplot2
        dplyr
        xts
      ];
    };
in

{
  environment.systemPackages = with pkgs; [
    R-with-my-packages
  ];
}
