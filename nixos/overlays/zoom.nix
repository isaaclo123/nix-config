self: super: {
  zoom-us = super.zoom-us.overrideAttrs (old: {
    version = "5.6.13558.0321";
    src = super.fetchurl {
      # url = "https://zoom.us/client/${version}/zoom_x86_64.pkg.tar.xz";
      url = "https://zoom.us/client/5.6.13558.0321/zoom_x86_64.pkg.tar.xz";
      sha256 = "KM8o2tgIn0lecOM4gKdTOdk/zsohlFqtNX+ca/S6FGY=";
    };
  });
}
