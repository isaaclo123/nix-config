with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "mpv-thumbnail";
  src = (pkgs.fetchFromGitHub {
    owner = "TheAMM";
    repo = "mpv_thumbnail_script";
    rev = "682becf5b5115c2a206b4f0bdee413d4be8b5bef";
    sha256 = "0dgfrb8ypc5vlq35kzn423fm6l6348ivl85vb6j3ccc9a51xprw3";
  });

  patchPhase = ''
    patchShebangs concat_files.py
  '';

  buildInputs = with pkgs; [
    python37
  ];

  installPhase = ''
    mkdir -p $out/scripts

    cp mpv_thumbnail_script_*.lua $out/scripts/.
    '';
}
