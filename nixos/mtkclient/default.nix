{ pkgs, ... }: {
  services.udev.extraRules = ''
    ${builtins.readFile ./51-edl.rules}
    ${builtins.readFile ./50-android.rules}

    SUBSYSTEM=="usb",ATTR{idVendor}=="0e8d", MODE="0660", GROUP="adbusers"
  '';

  users.users.isaac.extraGroups = [ "plugdev" "dialout" ];

  environment.systemPackages = with pkgs; [
    libusb1
    fuse2
    usbutils
  ];
}
