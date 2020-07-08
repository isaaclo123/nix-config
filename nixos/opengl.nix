{ pkgs, ... }:

# let
#   mesaDict = {
#     galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
#   };
#
#   mesa64 = (pkgs.mesa.override mesaDict);
#   mesa32 = (pkgs.pkgsi686Linux.mesa.override mesaDict);
# in

{
  # environment.variables = {
  #   MESA_LOADER_DRIVER_OVERRIDE = "iris";
  # };

  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [
      # (mesa.override mesaDict).drivers
      libva
    ];

    # accelerated video playback
    extraPackages = with pkgs; [
      # (vaapiIntel.override {
      #   enableHybridCodec = true;
      # })
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];

    # package = pkgs.mesa;
  };

  # services.xserver.videoDrivers = [ "iris" "intel" "vesa" ];
}
