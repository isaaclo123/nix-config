with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "rofimoji";
  src = fetchgit {
    url = "https://github.com/fdw/rofimoji";
    rev = "57e25307b2aedf173f901f4bd043e4c9028c5853";
    sha256 = "0hm5lcdi8hvx3r2fdl7nh4kx4n2hhcd29cxx4hkhhcbv4n2iwrdd";
  };

  propogatedBuildInputs = [ pkgs.python3 ];
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    chmod +x rofimoji.py
    cp rofimoji.py $out/bin/rofimoji
    sed -i $out/bin/rofimoji -e "s,#!/usr/bin/python3,#!${pkgs.python3}/bin/python3,"
    chmod +x $out/bin/rofimoji
  '';
}
