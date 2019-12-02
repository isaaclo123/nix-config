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
  ];

  programs.zsh.promptInit = ''
    # todo-txt
    t () {
        if [ -z "$1" ]
        then
            todo.sh -ls -c -N -t -a
        else
            todo.sh -c -N -t -a $@
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
        });
    };
  };
}
