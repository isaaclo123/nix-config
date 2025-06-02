{ pkgs, ...}: {
  # https://semyonsinchenko.github.io/ssinchenko/post/using-pyenv-with-nixos/
  home.sessionVariables = {
    PYENV_ROOT="$HOME/.pyenv";
    # pyenv flags to be able to install Python
    CPPFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include";
    CXXFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include";
    CFLAGS="-I${pkgs.openssl.dev}/include";
    LDFLAGS="-L${pkgs.zlib.out}/lib -L${pkgs.libffi.out}/lib -L${pkgs.readline.out}/lib -L${pkgs.bzip2.out}/lib -L${pkgs.openssl.out}/lib";
    CONFIGURE_OPTS="-with-openssl=${pkgs.openssl.dev}";
    PYENV_VIRTUALENV_DISABLE_PROMPT="1";
  };

  programs.pyenv.enable = true;

  home.packages = with pkgs; [
    # python3
    (pkgs.writeShellScriptBin "python" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      export LD_LIBRARY_PATH = ${pkgs.stdenv.cc.cc.lib}/lib:$NIX_LD_LIBRARY_PATH;
      exec ${pkgs.python3}/bin/python "$@"
    '')
    (pkgs.writeShellScriptBin "python3" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      export LD_LIBRARY_PATH = ${pkgs.stdenv.cc.cc.lib}/lib:$NIX_LD_LIBRARY_PATH;
      exec ${pkgs.python3}/bin/python "$@"
    '')
    python312Packages.pip
    python312Packages.numpy
    # (pkgs.pipenv.override { python3 = pkgs.python311; })
    pkgs.pipenv

    # gcc
    gnumake
    zlib
    libffi
    readline
    bzip2
    openssl
    ncurses
    openblas
  ];
}
