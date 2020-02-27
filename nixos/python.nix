{ pkgs, ... }:

with import <nixpkgs> {};

let my-python-packages = python-packages:
  let ueberzug = python3.pkgs.buildPythonPackage rec {
    pname = "ueberzug";
    version = "18.1.4";

    src = fetchurl {
      url = "https://github.com/seebye/ueberzug/archive/18.1.4.tar.gz";
      sha256 = "1yf9lmpmmjh6bk0q5yxy22zbx9qf60rd0zlq4r5rfdavhk7gak0q";
    };

    propagatedBuildInputs = with pkgs.python37Packages; [
      xlib
      psutil
      pillow
      docopt
      attrs
      pkgs.x11
    ];

    doCheck = false;
  }; in
  with python-packages; [
    cython
    opencv
    conda
    ueberzug
    requests
    virtualenv
    flake8
    tensorflow
    numpy
    scikitlearn
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
in

{
  environment.systemPackages = with pkgs; [
    python-with-my-packages
    pypi2nix
    pipenv
    opencv
    pkg-config
  ];
}
