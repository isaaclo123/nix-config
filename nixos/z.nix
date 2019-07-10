with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "z-1.9";
  src = fetchurl {
    url = "https://github.com/rupa/z/archive/v1.9.tar.gz";
    sha256 = "19vhvvhj5bg5pgfsrhcwpmcac8z63vn0ijm4ghlh43kpcm7hx1p2";
  };
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    chmod +x z.sh
    cp z.sh $out/bin/z
    cp z.1 $out/share/man/man1/
  '';
}
