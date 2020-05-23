{ pkgs, ... }:

{
  environment.variables = {
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
  };

  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

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

    package = (pkgs.mesa.override {
      galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
    }).drivers;
  };

  services.xserver.videoDrivers = [ "iris" "intel" "vesa" ];
}
