{ pkgs, ... }:

with import <nixpkgs> {};

let ueberzug = python3.pkgs.buildPythonPackage rec {
    pname = "ueberzug";
    version = "18.1.4";

    # src = python3.pkgs.fetchPypi {
    #   inherit pname version;
    #   sha256 = "43c2c9e5e7a16b6c88ba3088a9bfc82f7db8e13378be7c78d6c14a5f8ed05afd";
    # };

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

    # meta = {
    #   homepage = "https://github.com/pytoolz/toolz/";
    #   description = "List processing tools and functional utilities";
    # };
  }; in

with pkgs;

let my-python-packages = python-packages: with python-packages; [
    conda
    ueberzug
    # other python packages you want
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
in
{
  environment.systemPackages = with pkgs; [
    python-with-my-packages
  ];
}
