{ ... }:

let homedir = (import ./settings.nix).homedir; in

with import <nixpkgs> {};

let create-eval-funct = script: args:
  let eval-run = (pkgs.writeScript "eval-run.sh" ''
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
      PASSWORD_STORE_DIR='${homedir}/.password-store' pass show '$1' | head -n1
    ''); in
    name: create-eval-funct nix-pass [ name ];

  firstdir =
    let nix-firstdir = (pkgs.writeScript "nix-firstdir.sh" ''
      ls -d "$1"* | head -n1
    ''); in
    name: create-eval-funct nix-firstdir [ name ];
}
