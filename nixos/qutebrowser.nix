{ pkgs, ... }:

# Qutebrowser config.py
# Documentation:
# qute://help/configuring.html
# qute://help/settings.html

{
  environment.systemPackages =
    let qutebrowser-derivation =
      (with import <nixpkgs> {};
        stdenv.lib.overrideDerivation pkgs.unstable.qutebrowser (oldAttrs : {
          patches = oldAttrs.patches ++ [
            (pkgs.fetchurl {
              # https://gist.githubusercontent.com/isaaclo123/c73221c39dbfc0bacd72dd5d5a692973/raw/8e40d724a8cafe350a26d79a2e686c3074537b02/qutebrowser-qwerty-tab.patch
              # qutebrowser-qwerty-tab.patch
              url = "https://gist.githubusercontent.com/isaaclo123/c73221c39dbfc0bacd72dd5d5a692973/raw/8e40d724a8cafe350a26d79a2e686c3074537b02/qutebrowser-qwerty-tab.patch";
              sha256 = "1lvvw32ab955j8la5xyxd7lxdmfjqab1wn7wga4i9g3c2j3np5jk";
            })
          ];
      })); in
    with pkgs; [
      (qutebrowser-derivation)
    ];

  home-manager.users.isaac = {
    xdg.configFile = {
      "qutebrowser/config.py".text =
        let
          userContentCss = pkgs.fetchurl {
            url = "https://www.floppymoose.com/userContent.css";
            sha256 = "0bmlm6aslvgczzwpy1ijbi6h6f0n1qva4453ls5gv7x40c3qg8mq";
          }; in ''
            c = c # pylint: disable=undefined-variable,invalid-name
            config = config # pylint: disable=undefined-variable,invalid-name

            # Uncomment this to still load settings configured via autoconfig.yml
            # config.load_autoconfig()

            # Enable qutebrowser (host-based) adblock.
            # Type: Bool
            config.set('content.host_blocking.enabled', True)

            # Adblock lists.
            # Type: List
            config.set('content.host_blocking.lists', ["https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"]) # pylint: disable=line-too-long

            # User stylesheet (add floppymoose css rules http://www.floppymoose.com/)
            # Type: List
            config.set('content.user_stylesheets', ["${userContentCss}"]) # pylint: disable=line-too-long

            # Change editor.
            # Type: List
            config.set('editor.command', ['termite-open', 'vim {}'])

            # Tab close
            # Type: Option
            config.set('tabs.last_close', 'close')

            # Tab new position for unrelated
            # Type: Option
            config.set('tabs.new_position.unrelated', 'next')

            # Disable autoplay.
            # Type: Bool
            config.set('content.autoplay', False)

            # Enable JavaScript.
            # Type: Bool
            config.set('content.javascript.enabled', True, 'file://*')

            # Enable JavaScript.
            # Type: Bool
            config.set('content.javascript.enabled', True, 'chrome://*/*')

            # Enable JavaScript.
            # Type: Bool
            config.set('content.javascript.enabled', True, 'qute://*/*')

            # Bindings for normal mode
            config.unbind('d')
            config.unbind('D')
            config.bind('dd', 'tab-close')

            config.unbind('J')
            config.unbind('K')
            config.bind('J', 'tab-prev')
            config.bind('K', 'tab-next')

            config.bind('gT', 'tab-prev')
            config.bind('gt', 'tab-next')

            config.bind('<Ctrl-E>', 'scroll down')
            config.bind('<Ctrl-Y>', 'scroll up')

            config.unbind(';i')
            config.unbind(';I')
            config.bind(';p', 'hint images')
            config.bind(';P', 'hint images tab')

            config.bind('I', 'set-cmd-text -s :open --private')
            config.bind(';I', 'hint --rapid links run :open --private {hint-url}')

            # buffer change keybinds
            config.bind('<Alt-9>', 'buffer 9')
            config.bind('<Alt-0>', 'buffer 10')
            config.bind('<Alt-q>', 'buffer 11')
            config.bind('<Alt-w>', 'buffer 12')
            config.bind('<Alt-e>', 'buffer 13')
            config.bind('<Alt-r>', 'buffer 14')
            config.bind('<Alt-t>', 'buffer 15')
            config.bind('<Alt-y>', 'buffer 16')
            config.bind('<Alt-u>', 'buffer 17')
            config.bind('<Alt-i>', 'buffer 18')
            config.bind('<Alt-o>', 'buffer 19')
            config.bind('<Alt-p>', 'buffer 20')
            config.bind('<Alt-g>', 'set-cmd-text -s :buffer')

            # tor settings
            c.aliases["tor-cycle"] = "config-cycle -t -p content.proxy socks://0.0.0.0:9050/ system" # pylint: disable=line-too-long
            config.bind('tt', 'tor-cycle')

            # mpv settings

            # qute mpv background window
            config.bind('M', 'hint links spawn mpv-scratchpad-open {hint-url}')
            config.bind('m', 'spawn mpv-scratchpad-open {url}')

            # mpv normal open
            config.bind('<', 'hint links spawn mpv-window-open {hint-url}')
            config.bind(',', 'spawn mpv-window-open {url}')

            # pass settings
            c.aliases["qute-pass"] = "spawn --userscript ${pkgs.qutebrowser}/share/qutebrowser/userscripts/qute-pass" # pylint: disable=line-too-long
            config.bind('<z><l>', 'qute-pass')
            config.bind('<z><u><l>', 'qute-pass --username-only')
            config.bind('<z><p><l>', 'qute-pass --password-only')
            config.bind('<z><o><l>', 'qute-pass --otp-only')

            # password-fill settings
            # c.aliases["password-fill"] = "spawn --userscript ${pkgs.qutebrowser}/share/qutebrowser/userscripts/password_fill" # pylint: disable=line-too-long
            # config.bind('<z><z>', 'password-fill')

            # Base16-qutebrowser (https://github.com/theova/base16-qutebrowser)
            # Base16 qutebrowser template by theova
            # Atelier Sulphurpool scheme by Bram de Haan (http://atelierbramdehaan.nl)

            BASE00 = "#202746"
            BASE01 = "#293256"
            BASE02 = "#5e6687"
            BASE03 = "#6b7394"
            BASE04 = "#898ea4"
            BASE05 = "#979db4"
            BASE06 = "#dfe2f1"
            BASE07 = "#f5f7ff"
            BASE08 = "#c94922"
            BASE09 = "#c76b29"
            BASE0A = "#c08b30"
            BASE0B = "#ac9739"
            BASE0C = "#22a2c9"
            BASE0D = "#3d8fd1"
            BASE0E = "#6679cc"
            BASE0F = "#9c637a"

            # set qutebrowser colors

            # Text color of the completion widget. May be a single color to use for
            # all columns or a list of three colors, one for each column.
            c.colors.completion.fg = BASE05

            # Background color of the completion widget for odd rows.
            c.colors.completion.odd.bg = BASE00

            # Background color of the completion widget for even rows.
            c.colors.completion.even.bg = BASE00

            # Foreground color of completion widget category headers.
            c.colors.completion.category.fg = BASE07

            # Background color of the completion widget category headers.
            c.colors.completion.category.bg = BASE01

            # Top border color of the completion widget category headers.
            c.colors.completion.category.border.top = BASE01

            # Bottom border color of the completion widget category headers.
            c.colors.completion.category.border.bottom = BASE01

            # Foreground color of the selected completion item.
            c.colors.completion.item.selected.fg = BASE07

            # Background color of the selected completion item.
            c.colors.completion.item.selected.bg = BASE0E

            # Top border color of the completion widget category headers.
            c.colors.completion.item.selected.border.top = BASE0E

            # Bottom border color of the selected completion item.
            c.colors.completion.item.selected.border.bottom = BASE0E

            # Foreground color of the matched text in the completion.
            c.colors.completion.match.fg = BASE07

            # Color of the scrollbar handle in the completion view.
            c.colors.completion.scrollbar.fg = BASE00

            # Color of the scrollbar in the completion view.
            c.colors.completion.scrollbar.bg = BASE00

            # Background color for the download bar.
            c.colors.downloads.bar.bg = BASE01

            # Color gradient start for download text.
            c.colors.downloads.start.fg = BASE00

            # Color gradient start for download backgrounds.
            c.colors.downloads.start.bg = BASE0D

            # Color gradient end for download text.
            c.colors.downloads.stop.fg = BASE00

            # Color gradient stop for download backgrounds.
            c.colors.downloads.stop.bg = BASE0C

            # Foreground color for downloads with errors.
            c.colors.downloads.error.fg = BASE09

            # Font color for hints.
            c.colors.hints.fg = BASE07

            # Background color for hints. Note that you can use a `rgba(...)` value
            # for transparency.
            c.colors.hints.bg = BASE0E

            # Font color for the matched part of hints.
            c.colors.hints.match.fg = BASE06

            # border color for the matched part of hints.
            # c.hints.border = BASE0E
            config.set('hints.border', '1px solid {}'.format(BASE06))

            # Text color for the keyhint widget.
            c.colors.keyhint.fg = BASE05

            # Highlight color for keys to complete the current keychain.
            c.colors.keyhint.suffix.fg = BASE07

            # Background color of the keyhint widget.
            c.colors.keyhint.bg = BASE01

            # Foreground color of an error message.
            c.colors.messages.error.fg = BASE00

            # Background color of an error message.
            c.colors.messages.error.bg = BASE09

            # Border color of an error message.
            c.colors.messages.error.border = BASE09

            # Foreground color of a warning message.
            c.colors.messages.warning.fg = BASE00

            # Background color of a warning message.
            c.colors.messages.warning.bg = BASE0E

            # Border color of a warning message.
            c.colors.messages.warning.border = BASE0E

            # Foreground color of an info message.
            c.colors.messages.info.fg = BASE05

            # Background color of an info message.
            c.colors.messages.info.bg = BASE00

            # Border color of an info message.
            c.colors.messages.info.border = BASE00

            # Foreground color for prompts.
            c.colors.prompts.fg = BASE05

            # Border used around UI elements in prompts.
            c.colors.prompts.border = BASE00

            # Background color for prompts.
            c.colors.prompts.bg = BASE00

            # Background color for the selected item in filename prompts.
            c.colors.prompts.selected.bg = BASE0A

            # Foreground color of the statusbar.
            c.colors.statusbar.normal.fg = BASE0B

            # Background color of the statusbar.
            c.colors.statusbar.normal.bg = BASE01

            # Foreground color of the statusbar in insert mode.
            c.colors.statusbar.insert.fg = BASE00

            # Background color of the statusbar in insert mode.
            c.colors.statusbar.insert.bg = BASE0D

            # Foreground color of the statusbar in passthrough mode.
            c.colors.statusbar.passthrough.fg = BASE00

            # Background color of the statusbar in passthrough mode.
            c.colors.statusbar.passthrough.bg = BASE0C

            # Foreground color of the statusbar in private browsing mode.
            c.colors.statusbar.private.fg = BASE07

            # Background color of the statusbar in private browsing mode.
            c.colors.statusbar.private.bg = BASE02

            # Foreground color of the statusbar in command mode.
            c.colors.statusbar.command.fg = BASE05

            # Background color of the statusbar in command mode.
            c.colors.statusbar.command.bg = BASE01

            # Foreground color of the statusbar in private browsing + command mode.
            c.colors.statusbar.command.private.fg = BASE07

            # Background color of the statusbar in private browsing + command mode.
            c.colors.statusbar.command.private.bg = BASE02

            # Foreground color of the statusbar in caret mode.
            c.colors.statusbar.caret.fg = BASE00

            # Background color of the statusbar in caret mode.
            c.colors.statusbar.caret.bg = BASE0E

            # Foreground color of the statusbar in caret mode with a selection.
            c.colors.statusbar.caret.selection.fg = BASE00

            # Background color of the statusbar in caret mode with a selection.
            c.colors.statusbar.caret.selection.bg = BASE0D

            # Background color of the progress bar.
            c.colors.statusbar.progress.bg = BASE0D

            # Default foreground color of the URL in the statusbar.
            c.colors.statusbar.url.fg = BASE05

            # Foreground color of the URL in the statusbar on error.
            c.colors.statusbar.url.error.fg = BASE09

            # Foreground color of the URL in the statusbar for hovered links.
            c.colors.statusbar.url.hover.fg = BASE05

            # Foreground color of the URL in the statusbar on successful load
            # (http).
            c.colors.statusbar.url.success.http.fg = BASE0C

            # Foreground color of the URL in the statusbar on successful load
            # (https).
            c.colors.statusbar.url.success.https.fg = BASE0B

            # Foreground color of the URL in the statusbar when there's a warning.
            c.colors.statusbar.url.warn.fg = BASE0E

            # Background color of the tab bar.
            c.colors.tabs.bar.bg = BASE01

            # Color gradient start for the tab indicator.
            c.colors.tabs.indicator.start = BASE0D

            # Color gradient end for the tab indicator.
            c.colors.tabs.indicator.stop = BASE0C

            # Color for the tab indicator on errors.
            c.colors.tabs.indicator.error = BASE09

            # Foreground color of unselected odd tabs.
            c.colors.tabs.odd.fg = BASE05

            # Background color of unselected odd tabs.
            c.colors.tabs.odd.bg = BASE01

            # Foreground color of unselected even tabs.
            c.colors.tabs.even.fg = BASE05

            # Background color of unselected even tabs.
            c.colors.tabs.even.bg = BASE01

            # Foreground color of selected odd tabs.
            c.colors.tabs.selected.odd.fg = BASE07

            # Background color of selected odd tabs.
            c.colors.tabs.selected.odd.bg = BASE0E

            # Foreground color of selected even tabs.
            c.colors.tabs.selected.even.fg = BASE07

            # Background color of selected even tabs.
            c.colors.tabs.selected.even.bg = BASE0E

            # Background color for webpages if unset (or empty to use the theme's
            # color).
            # c.colors.webpage.bg = BASE00

            # Font
            c.fonts.monospace = "GohuFont"
            c.fonts.completion.category = "bold 14px monospace"
            c.fonts.completion.entry = "14px monospace"
            c.fonts.debug_console = "14px monospace"
            c.fonts.downloads = "14px monospace"
            c.fonts.hints = "bold 14px monospace"
            c.fonts.keyhint = "14px monospace"
            c.fonts.messages.error = "14px monospace"
            c.fonts.messages.info = "14px monospace"
            c.fonts.messages.warning = "14px monospace"
            c.fonts.prompts = "14px monospace"
            c.fonts.statusbar = "14px monospace"
            c.fonts.tabs = "14px monospace"
          '';
        };
  };
}
