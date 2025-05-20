{ config, lib, pkgs, ... }: {
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    # driSupport = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      libGL
      libGLU
      libglvnd
			mesa.drivers
      mesa
      openal
		];
  };
}
