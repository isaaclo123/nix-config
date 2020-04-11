{ ... }:

{
  # compton
  services.compton = {
    enable = true;
    backend = "glx";

    shadow = true;
    shadowOffsets = [ (-6) (-6) ];
    shadowOpacity = "0.3";
    shadowExclude = [
      "name != 'mpvscratchpad'"
    ];

    vSync = true;
    settings = {
      shadow-radius = 4;
      paint-on-overlay = true;
    };
  };
}
