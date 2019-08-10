{ config, lib, pkgs, ... }:

let slock-ext = (pkgs.slock.override {
  conf = ''
    /* user and group to drop privileges to */
    static const char *user  = "nobody";
    static const char *group = "nogroup";

    static const char *colorname[NUMCOLS] = {
      [INIT] =   "black",     /* after initialization */
      [INPUT] =  "#202746",   /* during input */
      [FAILED] = "black",   /* wrong password */
    };

    /* treat a cleared input like a wrong password (color) */
    static const int failonclear = 1;
  '';
}); in

{
  environment.systemPackages = with pkgs; [
    (slock-ext)
  ];

  security.wrappers.slock.source = "${slock-ext}/bin/slock";
}
