{ pkgs, ... }:

let
  homedir = (import ./settings.nix).homedir;
  username = (import ./settings.nix).username;
  fullname = (import ./settings.nix).fullname;
in

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
  environment.systemPackages = with pkgs; [
    neomutt
    # elinks
    w3m-full
    unstable.urlscan
    xclip
  ];

  home-manager.users."${username}" = {
    home.file = {
      ".mailcap".text = ''
        # text/html; elinks -dump -dump-color-mode 1 -no-numbering -no-references -dump-width 100; copiousoutput;
        text/html; w3m -I %{charset} -T text/html; copiousoutput;
        auto_view text/html

        image/*; sxiv %s; test=test -n "$DISPLAY";
        application/pdf; zathura %s; test=test -n "$DISPLAY"
      '';

      # ".urlview".text = ''
      #   COMMAND xdg-open
      # '';

      ".muttrc".text =
        let signature = (pkgs.writeText "sig" ''

          Isaac Lo

          Intern Software Developer, COUNTRY Financial
          1(650)-503-1253
        ''); in

        # accounts
        let
          personal = create-account "Personal" "isaaclo123@gmail.com" signature;
          school = create-account "School" "loxxx298@umn.edu" signature;
        in ''
          # editor settings

          # set editor="vim \"+set spell colorcolumn=80\" +/^$/ -c \"noh\" -c \"+set tw=80\""
          # set postpone=no

          set folder = ~/.mail
          set editor="vim"
          set edit_headers = yes
          set autoedit
          set auto_tag = yes
          set recall=ask-yes
          set text_flowed=yes
          set send_charset="us-ascii:utf-8"

          ## COLOR START (text then bg)

          color attachment  color12 color00
          color bold        color15 color00
          color error       color09 color00
          color hdrdefault  color15 color00
          # color indicator   color15 color16
          color indicator   color00 color07
          color markers     color16 color00
          color normal      color15 color00
          color quoted      color15 color00
          color quoted1     color14 color00
          color quoted2     color15 color00
          color quoted3     color14 color00
          color quoted4     color15 color00
          color quoted5     color14 color00
          color search      color00 color17
          color signature   color14 color00
          color status      color07 color16
          color tilde       color16 color00
          color tree        color10 color00
          color underline   color15 color16

          color sidebar_divider    color15 color00
          color sidebar_new        color10 color00

          color index color10 color00 ~N
          color index color14 color00 ~O
          color index color12 color00 ~P
          color index color11 color00 ~F
          color index color13 color00 ~Q
          color index color09 color00 ~=
          color index color00 color15 ~T
          color index color00 color09 ~D

          color header color11 color00 "^(To:|From:)"
          color header color10 color00 "^Subject:"
          color header color14 color00 "^X-Spam-Status:"
          color header color14 color00 "^Received:"

          color body color10 color00 "[a-z]{3,256}://[-a-zA-Z0-9@:%._\\+~#=/?&,]+"
          #color body color10 color00 "[a-zA-Z]([-a-zA-Z0-9_]+\\.){2,256}[-a-zA-Z0-9_]{2,256}"
          color body color17 color00 "[-a-z_0-9.%$]+@[-a-z_0-9.]+\\.[-a-z][-a-z]+"
          color body color17 color00 "mailto:[-a-z_0-9.]+@[-a-z_0-9.]+"
          color body color00 color11 "[;:]-*[)>(<lt;|]"
          color body color15 color00 "\\*[- A-Za-z]+\\*"

          color body color11 color00 "^-.*PGP.*-*"
          color body color10 color00 "^gpg: Good signature from"
          color body color09 color00 "^gpg: Can't.*$"
          color body color11 color00 "^gpg: WARNING:.*$"
          color body color09 color00 "^gpg: BAD signature from"
          color body color09 color00 "^gpg: Note: This key has expired!"
          color body color11 color00 "^gpg: There is no indication that the signature belongs to the owner."
          color body color11 color00 "^gpg: can't handle these multiple signatures"
          color body color11 color00 "^gpg: signature verification suppressed"
          color body color11 color00 "^gpg: invalid node with packet of type"

          color compose header            color15 color00
          color compose security_encrypt  color13 color00
          color compose security_sign     color12 color00
          color compose security_both     color10 color00
          color compose security_none     color17 color00

          ## COLOR END

          set sleep_time = 0

          # email settings
          set realname   = "${fullname}"
          set use_from=yes
          set envelope_from=yes

          unset move           # gmail does that
          set delete           # don't ask, just do
          unset confirmappend  # don't ask, just do!
          set quit             # don't ask, just do!!
          unset mark_old       # read/new is good enough for me

          # sort/threading
          set sort     = threads
          set sort_aux = reverse-last-date-received
          set sort_re

          # look and feel
          set pager_index_lines = 8
          set pager_context     = 5
          set pager_stop
          set menu_scroll
          set smart_wrap
          set tilde
          unset markers

          # composing
          set fcc_attach
          set forward_format = "Fwd: %s"
          set include
          set forward_quote
          unset mime_forward
          set mime_forward_rest=yes

          ignore *                               # first, ignore all headers
          unignore from: to: cc: date: subject:  # then, show only these
          hdr_order from: to: cc: date: subject: # and in this order

          # Navigation
          # ----------------------------------------------------

          bind generic             z         noop

          bind index,pager,attach g noop
          bind index,pager gi noop
          bind index,pager ga noop
          bind index,pager gd noop
          bind index,pager gs noop
          bind index,pager gt noop
          bind index,pager gf noop
          bind index,pager,attach,compose gx noop

          # bind index,pager,attach,compose y noop

          # bind index,pager,attach g noop
          # bind attach              g         noop
          bind index,pager         d         noop
          bind index,pager         s         noop
          bind index,pager         c         noop
          bind generic,pager       t         noop

          bind generic,index,pager \Cf       next-page
          bind generic,index,pager \Cb       previous-page
          bind generic,index       G         last-entry
          bind pager               G         bottom
          bind pager               gg        top
          bind generic             gg        first-entry
          bind generic,pager       \Cy       previous-line
          bind generic,index,pager \Ce       next-line
          bind generic,index,pager \Cd       half-down
          bind generic,index,pager \Cu       half-up
          # bind generic             zt        current-top
          # bind generic             zz        current-middle
          # bind generic             zb        current-bottom
          bind index               za        collapse-thread
          bind index               zA        collapse-all
          bind index,pager         N         search-opposite
          bind index               <Backtab> previous-new-then-unread

          # Actions
          # ----------------------------------------------------

          bind  index,pager    a   group-reply
          macro index,pager    dd  "<delete-message><sync-mailbox>"                                 "move message to trash"
          macro index,pager    dat "<delete-thread><sync-mailbox>"                                  "move thread to trash"
          macro index,pager    ss  ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<save-message>?"                                                                                                                                     "save message to a mailbox"
          macro index          sat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015\"\015<mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix-cond><save-message>?"                                    "save thread to a mailbox"
          macro index          \;s ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<tag-prefix-cond><save-message>?"                                                                                                                    "save tagged messages to a mailbox"
          macro pager          sat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015<display-message>\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015<display-message>\"\015<exit><mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix><save-message>?" "save thread to a mailbox"
          macro index,pager    cc  ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<copy-message>?"                                                                                                                                     "copy message to a mailbox"
          macro index          cat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015\"\015<mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix-cond><copy-message>?"                                    "copy thread to a mailbox"
          macro index          \;c ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<tag-prefix-cond><copy-message>?"                                                                                                                    "copy tagged messages to a mailbox"
          macro pager          cat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015<display-message>\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015<display-message>\"\015<exit><mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix><copy-message>?" "copy thread to a mailbox"
          bind  generic        tt  tag-entry
          bind  index          tat tag-thread
          bind  pager          tt  tag-message
          macro pager          tat "<exit><mark-message>q<enter><tag-thread>'q<display-message>"    "tag-thread"

          macro index,pager    gx  "<pipe-message>urlscan<Enter>"                                   "call urlscan to extract URLs out of a message"
          macro attach,compose gx  "<pipe-entry>urlscan<Enter>"                                     "call urlscan to extract URLs out of a message"

          # bind pager           gg top
          # bind generic         gg first-entry

          # Command Line
          # ----------------------------------------------------

          # bind editor \Cp history-up
          # bind editor \Cn history-down

          # vim keybinds
          # Keybindings and macros {{{1
          # ---------------------------

          # alias   - alias menu displaying suggested aliases
          # browser - file/directory browser
          # editor  - single line editor for `To:', `Subject:' prompts.
          # index   - the main menu showing messages in a folder
          # pager   - where the contents of the message are displayed
          # query   - menu displaying results of query command

          macro index <Space> <tag-entry>
          macro generic <Space> <tag-entry>
          macro pager <Space> <tag-message>
          bind index <Esc><Space> tag-thread
          macro pager <Esc><Space> "<exit><mark-message>q<enter><tag-thread>'q<display-message>"    "tag-thread"

          bind index { previous-thread
          bind pager { half-up

          bind index } next-thread
          bind pager } half-down

          bind index,pager A create-alias
          bind index,pager a group-reply

          # Skip trash when deleting with the delete key.
          bind index,pager <delete> purge-message

          # Readline-like history browsing using up/down keys.
          bind editor <up> history-up
          bind editor <down> history-down

          # forward normally different keybind
          # forward with all attachments
          # macro index,pager f "<view-attachments>jjjjjjjjjjjjjjjjjjjj<tag-message>k<tag-message>kk<tag-message>kk<tag-message>kk<tag-message>kk<tag-message>kk<tag-message>kk<tag-message>kk<tag-message>kk<tag-message>kk<tag-message>kk<tag-message>kk<tag-message>kk;<forward-message>"

          # Pipe message to xclip with X.  pipe_decode will ensure that
          # unnecessary headers are removed and the message is processed.

          macro index,pager,attach,compose X "<enter-command>set my_pipe_decode=\$pipe_decode pipe_decode<Enter><pipe-message>xclip<Enter><enter-command>set pipe_decode=\$my_pipe_decode; unset my_pipe_decode<Enter>" "copy message to clipboard using xclip"

          bind index H top-page
          bind index M middle-page
          bind index L bottom-page

          # toggle new
          bind index U toggle-new

          # Macros for switching accounts
          macro index,pager <f1> '<sync-mailbox><enter-command>source ${personal}<enter><change-folder>!<enter>'
          macro index,pager <f2> '<sync-mailbox><enter-command>source ${school}<enter><change-folder>!<enter>'

          # Macros for khard
          set query_command= "khard email --parsable %s"
          bind editor <Tab> complete-query
          bind editor ^T    complete

          macro index,pager A \
              "<pipe-message>khard add-email<return>" \
              "add the sender email address to khard"

          # Macros for notmuch
          # a notmuch query, showing only the results
          macro index \Cp "<enter-command>unset wait_key<enter><shell-escape>read -p 'notmuch query: ' x; echo \$x >/tmp/mutt_terms<enter><limit>~i \"\`notmuch search --output=messages \$(cat /tmp/mutt_terms) | head -n 600 | perl -le '@a=<>;chomp@a;s/\^id:// for@a;$,=\"|\";print@a'\`\"<enter>" "show only messages matching a notmuch pattern"

          # Fetch mail shortcut
          unset wait_key
          macro index r "<shell-escape>mail-sync &<enter>" "run mbsync and notmuch to sync all mail"

          set allow_ansi="yes"

          # viewing HTML mail
          auto_view text/html
          macro attach 'V' "<pipe-entry>tee /tmp/mutt.html 1>/dev/null && qutebrowser /tmp/mutt.html<enter>"
          bind attach <return> view-mailcap

          # multiple account setup
          source ${personal}

          folder-hook Personal/* source ${personal}
          folder-hook School/*   source ${school}
        '';
    };

    xdg.configFile = {
      "urlscan/config.json".text = ''
        {
            "palettes": {
                "default": [
                    [
                        "header",
                        "dark magenta",
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
                        "yellow",
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
                        "light cyan",
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
  };
}
