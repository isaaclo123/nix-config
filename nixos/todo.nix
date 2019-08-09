{ pkgs, ... }:

let todo-config = (pkgs.writeText "config" ''
  export TODO_DIR="$HOME/Documents/todo"
  export TODO_FILE="$TODO_DIR/todo.txt"
  export DONE_FILE="$TODO_DIR/done.txt"
  export REPORT_FILE="$TODO_DIR/report.txt"
  export TMP_FILE="/tmp/todo.tmp"
  export TODOTXT_DEFAULT_ACTION=ls
  export TODOTXT_SORT_COMMAND="env LC_COLLATE=C sort -k 2,2 -k 1,1n"
''); in

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

  home-manager.users.isaac = {
    home.file = {
      ".todo/config".source = todo-config;
    };
  };
}
