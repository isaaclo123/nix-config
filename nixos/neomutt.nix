{ pkgs, ... }:

let homedir = "/home/isaac"; in
let configdir = "${homedir}/.nixpkgs"; in

let mailcap = (pkgs.writeText "mailcap" ''
  # auto view using w3m
  # text/html; w3m -I %{charset} -T text/html; copiousoutput;
  # text/html;    elinks -dump -dump-color-mode 3 -no-references -default-mime-type text/html %s; needsterminal; copiousoutput;

  # text/html;    elinks %s; nametemplate=%s.html
  text/html;    w3m %s; nametemplate=%s.html
  text/html; w3m -I %{charset} -T text/html; copiousoutput;
  # text/html;    elinks -dump -dump-color-mode 1 -no-references -dump-charset utf-8 --default-mime-type text/html %s; needsterminal; copiousoutput;
  # text/html; elinks -dump -dump-color-mode 3 \
  #     dump-charset utf-8 -default-mime-type text/htm %s; \
  #     copiousoutput

  image/*; sxiv %s; test=test -n "$DISPLAY";
  application/pdf; zathura %s; test=test -n "$DISPLAY"
''); in

# take a folder name and email to produce a sourcable file
let account = folder: email: signature: (pkgs.writeText folder ''
  set spoolfile = "+${folder}/Inbox"

  set from      = "${email}"
  set sendmail  = "msmtp"
  set mbox      = "+${folder}/archive"
  set postponed = "+${folder}/[Gmail]/Drafts"
  set record    = "+${folder}/Sent"
  set trash     = "+${folder}/Trash"
  set signature="${signature}"

  bind index,pager g noop
  bind index,pager gi noop
  bind index,pager ga noop
  bind index,pager gd noop
  bind index,pager gs noop
  bind index,pager gt noop
  bind index,pager gf noop

  # Go to folder...
  macro index,pager gi "<change-folder>=${folder}/Inbox<enter>"       "open inbox"
  macro index,pager ga "<change-folder>=${folder}/archive<enter>"      "open archive"
  macro index,pager gd "<change-folder>=${folder}/[Gmail]/Drafts<enter>"      "open drafts"
  macro index,pager gs "<change-folder>=${folder}/Sent<enter>"        "open sent"
  macro index,pager gt "<change-folder>=${folder}/Trash<enter>"       "open trash"
  macro index,pager gf "<change-folder>?"                   "open mailbox..."
''); in

let signature = (pkgs.writeText "sig" ''
  --

  Isaac Lo

  220 Delaware Street
  Minneapolis, MN 55455
  1(650)-503-1253
''); in

# accounts
let personal = account "Personal" "isaaclo123@gmail.com" signature; in
let school = account "School" "loxxx298@umn.edu" signature; in

let muttrc = (pkgs.writeText "muttrc" ''
  # editor settings

  set folder = ~/.mail
  # set editor="vim \"+set spell colorcolumn=80\" +/^$/ -c \"noh\" -c \"+set tw=80\""
  set editor="vim"
  set edit_headers = yes
  set autoedit
  set auto_tag = yes
  set recall=no
  # set postpone=no

  ## COLOR START

  # base16-mutt: base16-shell support for mutt
  #
  # These depend on mutt compiled with s-lang, not ncurses. Check by running `mutt -v`
  # Details this configuration may be found in the mutt manual:
  # §3 Patterns <http://www.mutt.org/doc/manual/#patterns>
  # §9 Using color and mono video attributes <http://www.mutt.org/doc/manual/#color>

  # https://www.neomutt.org/guide/configuration.html#color
  # base00 : color00 - Default Background
  # base01 : color18 - Lighter Background (Used for status bars)
  # base02 : color19 - Selection Background
  # base03 : color08 - Comments, Invisibles, Line Highlighting

  # base04 : color20 - Dark Foreground (Used for status bars)
  # base05 : color07 - Default Foreground, Caret, Delimiters, Operators
  # base06 : color21 - Light Foreground (Not often used)
  # base07 : color15 - Light Background (Not often used)

  # base08 : color01 - Index Item: Deleted.
  # base09 : color16 - Message: URL.
  # base0A : color03 - Search Text Background. Message: Bold.
  # base0B : color02 - Message: Code. Index Item: Tagged.
  # base0C : color06 - Message: Subject, Quotes. Index Item: Trusted.
  # base0D : color04 - Message: Headings.
  # base0E : color05 - Message: Italic, Underline. Index Item: Flagged.
  # base0F : color17 - Deprecated, Opening/Closing Embedded Language Tags e.g.

  ## Base
  color normal      color07  color00 # softer, bold

  ## Weak
  color tilde       color08  color00  # `~` padding at the end of pager
  color attachment  color08  color00
  color tree        color08  color00  # arrow in threads
  color signature   color08  color00
  color markers     color08  color00  # `+` wrap indicator in pager

  ## Strong
  color bold        color21  color00
  color underline   color21  color00

  ## Highlight
  color error       color01  color00
  color message     color04  color00  # informational messages
  color search      color08  color03
  color status      color20  color19
  color indicator   color21  color19  # inverse, brighter


  # Message Index ----------------------------------------------------------------

  ## Weak
  color index  color08  color00  "~R"        # read messages
  color index  color08  color00  "~d >45d"   # older than 45 days
  color index  color08  color00  "~v~(!~N)"  # collapsed thread with no unread
  color index  color08  color00  "~Q"        # messages that have been replied to

  ## Strong
  color index  color21  color00  "(~U|~N|~O)"     # unread, new, old messages
  color index  color21  color00  "~v~(~U|~N|~O)"  # collapsed thread with unread

  ## Highlight
  ### Trusted
  color index  color06  color00  "~g"  # PGP signed messages
  color index  color06  color00  "~G"  # PGP encrypted messages
  ### Odd
  color index  color01  color00  "~E"  # past Expires: header date
  color index  color01  color00  "~="  # duplicated
  color index  color01  color00  "~S"  # marked by Supersedes: header
  ### Flagged
  color index  color05  color00  "~F"       # flagged messages
  color index  color02  color00  "~v~(~F)"  # collapsed thread with flagged inside

  # Selection
  color index  color02  color18   "~T"  # tagged messages
  color index  color01  color18   "~D"  # deleted messages

  ### Message Headers ----------------------------------------------------

  # Base
  color hdrdefault  color07  color00
  color header      color07  color00  "^"
  # Strong
  color header      color21  color00  "^(From)"
  # Highlight
  color header      color04  color00  "^(Subject)"

  ### Message Body -------------------------------------------------------
  # When possible, these regular expressions attempt to match http://spec.commonmark.org/
  ## Weak
  # ~~~ Horizontal rules ~~~
  color body  color08  color00  "([[:space:]]*[-+=#*~_]){3,}[[:space:]]*"
  ## Strong
  # *Bold* span
  color body  color03  color00  "(^|[[:space:][:punct:]])\\*[^*]+\\*([[:space:][:punct:]]|$)"
  # _Underline_ span
  color body  color05  color00  "(^|[[:space:][:punct:]])_[^_]+_([[:space:][:punct:]]|$)"
  # /Italic/ span (Sometimes gets directory names)
  color body  color05  color00  "(^|[[:space:][:punct:]])/[^/]+/([[:space:][:punct:]]|$)"
  # ATX

  ## COLOR END

  # Theme
  color status color07 color18 # status bar

  color index  color04  color00  "~F"       # flagged messages
  color index  color04  color18  "~v~(~F)"  # collapsed thread with flagged inside

  color indicator   color15  color19  # inverse, brighter
  color tree   color02  color00  # arrow in threads

  color index  color08  color18  "~v~(!~N)"  # collapsed thread with no unread

  color index  color15  color00  "(~U|~N|~O)"     # unread, new, old messages
  color index  color15  color18  "~v~(~U|~N|~O)"  # collapsed thread with unread

  # multiple account setup
  source ${personal}

  folder-hook Personal/* source ${personal}
  folder-hook School/*   source ${school}

  set sleep_time = 0

  set realname   = "Isaac Lo"

  unset move           # gmail does that
  set delete           # don't ask, just do
  unset confirmappend  # don't ask, just do!
  set quit             # don't ask, just do!!
  unset mark_old       # read/new is good enough for me

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
  macro index r "<shell-escape>mail-sync<enter>" "run mbsync and notmuch to sync all mail"

  set allow_ansi="yes"

  # viewing HTML mail
  auto_view text/html
  macro attach 'V' "<pipe-entry>tee /tmp/mutt.html 1>/dev/null && qutebrowser /tmp/mutt.html<enter>"
  bind attach <return> view-mailcap

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
  bind attach              g         noop
  bind index,pager         d         noop
  bind index,pager         s         noop
  bind index,pager         c         noop
  bind generic,pager       t         noop

  bind generic,index,pager \Cf       next-page
  bind generic,index,pager \Cb       previous-page
  bind generic             gg        first-entry
  bind generic,index       G         last-entry
  bind pager               gg        top
  bind pager               G         bottom
  # bind generic,pager       \Cy       previous-line
  # bind generic,index,pager \Ce       next-line
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

  macro index,pager    gx  "<pipe-message>urlview<Enter>"                                   "call urlview to extract URLs out of a message"
  macro attach,compose gx  "<pipe-entry>urlview<Enter>"                                     "call urlview to extract URLs out of a message"

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

  # Pipe message to xclip with yy.  pipe_decode will ensure that
  # unnecessary headers are removed and the message is processed.
  macro index,pager,attach,compose \cy "<enter-command>set my_pipe_decode=\$pipe_decode pipe_decode<Enter><pipe-message>xclip<Enter><enter-command>set pipe_decode=\$my_pipe_decode; unset my_pipe_decode<Enter>" "copy message to clipboard using xclip"

  bind index H top-page
  bind index M middle-page
  bind index L bottom-page
''); in

{
  environment.systemPackages = with pkgs; [
    neomutt
  ];

  home-manager.users.isaac = {
    home.file = {
      ".mailcap".source = mailcap;
      ".muttrc".source = muttrc;
    };
  };
}
