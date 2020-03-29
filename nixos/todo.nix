{ pkgs, lib, ... }:

let
  username = (import ./settings.nix).username;
  homedir = (import ./settings.nix).homedir;
in

let todo-map-string = config-map:
  lib.concatMapStringsSep "\n"
    (key: "export ${key}=\"${builtins.getAttr key config-map}\"")
    (builtins.attrNames config-map); in

{
  environment.systemPackages = with pkgs; [
    todo-txt-cli
    grc
  ];

  programs.zsh.promptInit = ''
    # todo-txt
    t () {
        if [ -z "$1" ]
        then
            todo.sh -ls -c -N -t -A | grcat conf.todo
        else
            todo.sh -c -N -t -A $@ | grcat conf.todo
        fi
    }
  '';

  home-manager.users."${username}" = {
    home.file = {
      ".todo/config".text =
        "export TODO_DIR=${homedir}/Documents/todo\n" +
        (todo-map-string {
          TODO_FILE="$TODO_DIR/todo.txt";
          DONE_FILE="$TODO_DIR/done.txt";
          REPORT_FILE="$TODO_DIR/report.txt";
          TMP_FILE="/tmp/todo.tmp";
          TODOTXT_DEFAULT_ACTION="ls";
          TODOTXT_SORT_COMMAND="env LC_COLLATE=C sort -k 2,2 -k 1,1n";

          PRI_A="$NONE";
          PRI_B="$NONE";
          PRI_C="$NONE";
          PRI_D="$NONE";
          PRI_X="$NONE";
          COLOR_DONE="$NONE";
        });

        ".grc/conf.todo".source = (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/sceox/todo.txt-color/master/conf.todo";
          sha256 = "1szwwin6kkbmdj92qjr5lx5zb9brh3jbxi4qgsnmiqqkm7k1y9ax";
        });
    };
  };
}
