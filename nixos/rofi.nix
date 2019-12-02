{ pkgs, ... }:

let username = (import ./settings.nix).username; in

{
  environment.systemPackages = with pkgs; [
    rofi
  ];

  home-manager.users."${username}" = {
    xdg.configFile = {
      "rofi/config".text = ''
        /*
        ! ------------------------------------------------------------------------------
        ! ROFI Color theme
        ! ------------------------------------------------------------------------------
        rofi.font: Gohu Font 14px
        rofi.scrollbar-width: 0px
        rofi.bw: 4px
        rofi.padding: 12px
        rofi.color-enabled: true
        ! State:           'bg',    'fg',    'bgalt', 'hlbg',  'hlfg'
        rofi.color-window: #202746, #6679cc, #202746
        rofi.color-normal: #202746, #979db4, #202746, #6679cc, #f5f7ff
        rofi.color-active: #202746, #22a2c9, #f5f7ff, #22a2c9, #f5f7ff
        rofi.color-urgent: #202746, #3d8fd1, #202746, #3d8fd1, #f5f7ff
        */
      '';
    };
  };
}
