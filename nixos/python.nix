{ pkgs, ... }:

let
  homedir = (import ./settings.nix).homedir;
in

let my-python-packages = python-packages:
  let
    rofimoji = pkgs.python3.pkgs.buildPythonPackage rec {
      pname = "rofimoji";
      version = "4.1.1";

      src = builtins.fetchurl {
        url = "https://github.com/fdw/rofimoji/archive/4.1.1.tar.gz";
        sha256 = "09xm13i8n16g0gbvb7fhnbla34nq7c893y83rgb81qxp8vjkdnbh";
      };

      propagatedBuildInputs = with pkgs.python37Packages; [
        pyxdg
        ConfigArgParse
      ];

      doCheck = false;
    };

  in with python-packages; [
    (rofimoji)

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
  python-with-my-packages = pkgs.python3.withPackages my-python-packages;
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
    pipenv

    python-with-my-packages
    pypi2nix
    opencv
    pkg-config
  ];
}
