{ config, pkgs, stdenv, ... }:

{
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
  '';

  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  # Enable sound.
  sound = {
    enable = true;
    enableOSSEmulation = true;
    # extraConfig = ''
    #   # pcm.rear cards.pcm.default
    #   # pcm.center_life cards.pcm.default
    #   # pcm.side cards.pcm.default

    #   pcm.!default {
    #     type hw
    #     card 0
    #   }
    # '';
  };
  # sound.extraConfig = ''
  #   pcm.!default {
  #     type hw
  #     card 1
  #   }

  #   ctl.!default {
  #     type hw
  #     card 0
  #   }
  # '';

  hardware.pulseaudio = {
    # package = (pkgs.pulseaudioFull.override {
    #   x11Support = true;
    # });
    enable = true;
    daemon = {
      config = {
        realtime-scheduling = "yes";
      };
    };
    support32Bit = true;
    # configFile = pkgs.runCommand "default.pa" {} ''
    #   sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
    #     ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
    # '';
  };

  security.rtkit.enable = true;
}
