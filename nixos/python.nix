{ pkgs, ... }:

let
  homedir = (import ./settings.nix).homedir;
in

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
      pynvim
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
    # opencv
    conda
    ueberzug
    requests
    virtualenv
    flake8
    tensorflow
    numpy
    scikitlearn
    ipykernel
    matplotlib
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
in

{
  environment.variables = {
    SOURCE_DATE_EPOCH="$(date +%s)";
    PYTHONEXECUTABLE="${python-with-my-packages}/bin/python3.7";
    PYTHONPATH="${python-with-my-packages}/lib/python3.7/site-packages";
  };

  services.jupyter = {
    enable = false;
    group = "users";
    kernels = {
      python3 = {
        displayName = "Python 3";
        argv = [
          "${python-with-my-packages.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
        language = "python";
      };
    };
    notebookDir = homedir;
    password = "sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba"; # test
  };

  environment.systemPackages = with pkgs; [
    unstable.pipenv

    python-with-my-packages
    pypi2nix
    opencv
    pkg-config
  ];
}
