{ config, lib, pkgs, ... }: {
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

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
