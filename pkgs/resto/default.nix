{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "operator-mono-nerdfont";
  version = "2.000";

  src = pkgs.fetchFromGitHub {
    # owner = "TarunDaCoder";
    # repo = "OperatorMono_NerdFont";
    # rev = "d8e2ac4d8ec637cf02e8847870b882a0c6ce6034";
    # hash = "sha256-jECkRLoBOYe6SUliAY4CeCFt9jT2GjS6bLA7c/N4uaY=";
      owner = "40huo";
      repo = "Patched-Fonts";
      rev = "8482be17cf4a8b0397be449db37fb5aba0491d1f";
      hash = "sha256-3lIZX8pwiwld4uPcGd0wx1xCS0vNHTHKcaWLvM0H3Ro=";
  };

  installPhase = ''
    runHook preInstall

    # install -Dm644 OperatorMonoNF/*.otf -t $out/share/fonts/opentype
    install -Dm644 operator-mono-nerd-font/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';
}
