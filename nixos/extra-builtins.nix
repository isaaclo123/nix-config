{ ... }:

with import <nixpkgs> {};

let create-eval-funct = script: args:
  let eval-run = (pkgs.writeScript "eval-run.sh" ''
    #!${pkgs.bash}/bin/bash

    set -euo pipefail

    f=$(mktemp)
    trap "rm $f" EXIT
    ${script} "$@" > $f
    nix-instantiate --eval -E "builtins.readFile $f"
  ''); in
  builtins.exec ([ "${eval-run}" ] ++ args);
in

{
  pass =
    let nix-pass = (pkgs.writeScript "nix-pass.sh" ''
    #!${pkgs.bash}/bin/bash

      pass show "$1" | head -n1
    ''); in
    name: create-eval-funct nix-pass [ name ];

  firstdir =
    let nix-firstdir = (pkgs.writeScript "nix-firstdir.sh" ''
      #!${pkgs.bash}/bin/bash

      ls -d "$1"* | head -n1
    ''); in
    name: create-eval-funct nix-firstdir [ name ];
}
