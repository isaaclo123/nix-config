{ pkgs, ... }:

# take a folder name and email to produce a sourcable account file
let create-account = folder: email: signature: (pkgs.writeText folder ''
  set spoolfile = "+${folder}/Inbox"

  set from      = "${email}"
  set sendmail  = "msmtp"
  set mbox      = "+${folder}/archive"
  set postponed = "+${folder}/[Gmail]/Drafts"
  set record    = "+${folder}/Sent"
  set trash     = "+${folder}/Trash"
  set signature="${signature}"

  # Go to folder...
  macro index,pager gi "<change-folder>=${folder}/Inbox<enter>"       "open inbox"
  macro index,pager ga "<change-folder>=${folder}/archive<enter>"      "open archive"
  macro index,pager gd "<change-folder>=${folder}/[Gmail]/Drafts<enter>"      "open drafts"
  macro index,pager gs "<change-folder>=${folder}/Sent<enter>"        "open sent"
  macro index,pager gt "<change-folder>=${folder}/Trash<enter>"       "open trash"
  macro index,pager gf "<change-folder>?"                   "open mailbox..."
''); in

{
  home.packages = with pkgs; [
    neomutt
    # elinks
    w3m-full
    urlscan
    xclip
  ];

  home.file = {
    ".mailcap".text = ''
      # text/html; elinks -dump -dump-color-mode 1 -no-numbering -no-references -dump-width 100; copiousoutput;
      text/html; w3m -I %{charset} -T text/html; copiousoutput;
      auto_view text/html

      image/*; sxiv %s; test=test -n "$DISPLAY";
      application/pdf; zathura %s; test=test -n "$DISPLAY"
    '';

    ".muttrc".text =
      let signature = (pkgs.writeText "sig" ''

        Isaac Lo

        Software Developer, Classranked 
        1(650)-503-1253
      ''); in

      # accounts
      let
        personal = create-account "Personal" "isaaclo123@gmail.com" signature;
        school = create-account "School" "loxxx298@umn.edu" signature;
        work = create-account "Work" "isaac.lo@classranked.com" signature;
      in ''
        ${builtins.readFile ./powerline.neomuttrc}
        ${builtins.readFile ./colors-powerline.neomuttrc}
        ${builtins.readFile ./.neomuttrc}

        # Macros for switching accounts
        macro index,pager <f1> '<sync-mailbox><enter-command>source ${personal}<enter><change-folder>!<enter>'
        macro index,pager <f2> '<sync-mailbox><enter-command>source ${school}<enter><change-folder>!<enter>'
        macro index,pager <f3> '<sync-mailbox><enter-command>source ${work}<enter><change-folder>!<enter>'

        # multiple account setup
        source ${personal}

        folder-hook Personal/* source ${personal}
        folder-hook School/* source ${school}
        folder-hook Work/* source ${work}
      '';
  };

  xdg.configFile = {
    "urlscan/config.json".text = ''
      {
          "palettes": {
              "default": [
                  [
                      "header",
                      "light cyan",
                      "black",
                      "standout"
                  ],
                  [
                      "footer",
                      "white",
                      "black",
                      "standout"
                  ],
                  [
                      "search",
                      "black",
                      "brown",
                      "standout"
                  ],
                  [
                      "msgtext",
                      "",
                      ""
                  ],
                  [
                      "msgtext:ellipses",
                      "light gray",
                      "black"
                  ],
                  [
                      "urlref:number:braces",
                      "light gray",
                      "black"
                  ],
                  [
                      "urlref:number",
                      "light green",
                      "black",
                      "standout"
                  ],
                  [
                      "urlref:url",
                      "white",
                      "black",
                      "standout"
                  ],
                  [
                      "url:sel",
                      "yellow",
                      "black",
                      "bold"
                  ]
              ],
              "bw": [
                  [
                      "header",
                      "black",
                      "light gray",
                      "standout"
                  ],
                  [
                      "footer",
                      "black",
                      "light gray",
                      "standout"
                  ],
                  [
                      "search",
                      "black",
                      "light gray",
                      "standout"
                  ],
                  [
                      "msgtext",
                      "",
                      ""
                  ],
                  [
                      "msgtext:ellipses",
                      "white",
                      "black"
                  ],
                  [
                      "urlref:number:braces",
                      "white",
                      "black"
                  ],
                  [
                      "urlref:number",
                      "white",
                      "black",
                      "standout"
                  ],
                  [
                      "urlref:url",
                      "white",
                      "black",
                      "standout"
                  ],
                  [
                      "url:sel",
                      "black",
                      "light gray",
                      "bold"
                  ]
              ]
          },
          "keys": {
              "/": "search_key",
              "0": "digits",
              "1": "digits",
              "2": "digits",
              "3": "digits",
              "4": "digits",
              "5": "digits",
              "6": "digits",
              "7": "digits",
              "8": "digits",
              "9": "digits",
              "C": "clipboard",
              "c": "context",
              "ctrl l": "clear_screen",
              "f1": "help_menu",
              "G": "bottom",
              "g": "top",
              "j": "down",
              "k": "up",
              "P": "clipboard_pri",
              "l": "link_handler",
              "p": "palette",
              "Q": "quit",
              "q": "quit",
              "S": "all_shorten",
              "s": "shorten",
              "u": "all_escape"
          }
      }
    '';
  };
}
