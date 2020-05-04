{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cabal2nix
    cabal-install
    ghc

    haskellPackages.hoogle
    haskellPackages.hindent
    # haskellPackages.stylish-haskell
  ];
}
