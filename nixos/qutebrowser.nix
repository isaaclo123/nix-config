{ pkgs, ... }:

let
  username = (import ./settings.nix).username;
  homedir = (import ./settings.nix).homedir;
  font = (import ./settings.nix).font;
  rofi = (import ./settings.nix).rofi;
in

# Qutebrowser config.py
# Documentation:
# qute://help/configuring.html
# qute://help/settings.html

{
  environment.systemPackages =
    # let qutebrowser-derivation =
    #   (with import <nixpkgs> {};
    #     stdenv.lib.overrideDerivation pkgs.unstable.qutebrowser (oldAttrs : {
    #       python3Packages = python3.8;
    #       srcs =  [(pkgs.fetchurl {
    #           # https://gist.githubusercontent.com/isaaclo123/c73221c39dbfc0bacd72dd5d5a692973/raw/8e40d724a8cafe350a26d79a2e686c3074537b02/qutebrowser-qwerty-tab.patch
    #           # qutebrowser-qwerty-tab.patch
    #           url = "https://github.com/qutebrowser/qutebrowser/archive/v2.0.2.tar.gz";
    #           sha256 = "05ch8jwlhkx697v63pn3srxxr493iyxbw7br1zy28im2n6mcqc48";
    #         })
    #       # patches = oldAttrs.patches ++ [
    #       #   (pkgs.fetchurl {
    #       #     # https://gist.githubusercontent.com/isaaclo123/c73221c39dbfc0bacd72dd5d5a692973/raw/8e40d724a8cafe350a26d79a2e686c3074537b02/qutebrowser-qwerty-tab.patch
    #       #     # qutebrowser-qwerty-tab.patch
    #       #     url = "https://gist.githubusercontent.com/isaaclo123/c73221c39dbfc0bacd72dd5d5a692973/raw/8e40d724a8cafe350a26d79a2e686c3074537b02/qutebrowser-qwerty-tab.patch";
    #       #     sha256 = "1lvvw32ab955j8la5xyxd7lxdmfjqab1wn7wga4i9g3c2j3np5jk";
    #       #   })
    #       ];
    #   })); in
    with pkgs; [
      # (qutebrowser-derivation)
      unstable.qutebrowser
    ];

  home-manager.users."${username}" = {
    home.file = {
      ".local/share/qutebrowser/greasemonkey/anti-adblock-killer.user.js".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/reek/anti-adblock-killer/9a933f417f0fd074935b23ef2d8ad0fa0c62631c/anti-adblock-killer.user.js";
        sha256 = "0way11wrl9lpmi4s8l99is8s2vfnm0r8358zs769x9pfbjahxqp2";
      };
    };

    xdg.configFile = {
      "qutebrowser/config.py".text =
        let
          theme = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/theova/base16-qutebrowser/c5da33b3d50cd30f18a50beac8bb2219c11213d9/themes/minimal/base16-gruvbox-dark-hard.config.py";
            sha256 = "1b1klfpgg0afg1jgpycx87d3f002ccv391nbkz0jz6grnbq79n2s";
          };

          user-content-css = pkgs.fetchurl {
            url = "https://www.floppymoose.com/userContent.css";
            sha256 = "0bmlm6aslvgczzwpy1ijbi6h6f0n1qva4453ls5gv7x40c3qg8mq";
          }; in ''
            import sys, os

            config.load_autoconfig(False);

            # START THEME

            ${builtins.readFile theme}

            # END THEME

            # Uncomment this to still load settings configured via autoconfig.yml
            # config.load_autoconfig()

            # Enable qutebrowser adblock.
            # Type: Bool
            config.set('content.blocking.enabled', True)

            # Dark mode Settings
            c.colors.webpage.bg = base00
            c.colors.webpage.darkmode.enabled = True
            c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
            c.colors.webpage.darkmode.contrast = 0.5
            c.colors.webpage.darkmode.policy.images = 'smart'
            c.colors.webpage.darkmode.policy.page = 'smart'
            c.colors.webpage.darkmode.threshold.text = 150
            c.colors.webpage.darkmode.threshold.background = 205
            c.colors.webpage.prefers_color_scheme_dark = True

            # Adblock lists.
            # Type: List
            config.set('content.blocking.adblock.lists', [
              "https://easylist.to/easylist/easylist.txt",
              "https://easylist.to/easylist/easyprivacy.txt",
              "https://easylist.to/easylist/fanboy-annoyance.txt",
              "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt",

              # anti adblock killer cont.
              "https://raw.githubusercontent.com/reek/anti-adblock-killer/master/anti-adblock-killer-filters.txt",
              "https://gitlab.com/xuhaiyang1234/AAK-Cont/raw/master/FINAL_BUILD/aak-cont-list-notubo.txt",

              # "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
              # "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt",
              # "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt",
              # "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
              # "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt",
              # "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt",
              # "https://www.malwaredomainlist.com/hostslist/hosts.txt",
              # "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&mimetype=plaintext",
            ])

            # Searchengines
            config.set('url.searchengines', {
              "DEFAULT": "https://duckduckgo.com/?q={}",
              "y": "https://www.youtube.com/results?search_query={}",
              "w": "https://en.wikipedia.org/w/index.php?search={}&title=Special:Search",
              "g": "https://www.google.com/search?q={}",
              "r": "https://doc.rust-lang.org/std/index.html?search={}"
            })

            ## User agent
            config.set('content.headers.user_agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0')
            config.set('content.headers.accept_language', 'en-US,en;q=0.5')
            # config.set('content.headers.custom', {"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"})

            # User stylesheet (add floppymoose css rules http://www.floppymoose.com/)
            # Type: List
            config.set('content.user_stylesheets', ["${user-content-css}"])

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

            # Allow javascript to open tabs
            config.set('content.javascript.can_open_tabs_automatically', True)

            # hiding tab bindings
            config.bind('xx', 'config-cycle statusbar.show always never;; config-cycle tabs.show always switching')
            config.bind('xt', 'config-cycle tabs.show always switching')
            config.bind('xb', 'config-cycle statusbar.show always never')

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
            c.aliases["tor-cycle"] = "config-cycle -t -p content.proxy http://0.0.0.0:8118/ system" # pylint: disable=line-too-long
            config.bind('tt', 'tor-cycle')

            # mpv settings

            # qute mpv background window
            config.bind('M', 'hint links spawn mpv-scratchpad-open {hint-url}')
            config.bind('m', 'spawn mpv-scratchpad-open {url}')

            # mpv normal open
            config.bind('<', 'hint links spawn mpv-window-open {hint-url}')
            config.bind(',', 'spawn mpv-window-open {url}')

            # pass settings
            c.aliases["qute-pass"] = "spawn --userscript ${pkgs.qutebrowser}/share/qutebrowser/userscripts/qute-pass -d 'rofi ${rofi.args} -dmenu'"
            config.bind('<z><l>', 'qute-pass')
            config.bind('<z><u><l>', 'qute-pass --username-only')
            config.bind('<z><p><l>', 'qute-pass --password-only')
            config.bind('<z><o><l>', 'qute-pass --otp-only')

            # password-fill settings
            # c.aliases["password-fill"] = "spawn --userscript ${pkgs.qutebrowser}/share/qutebrowser/userscripts/password_fill" # pylint: disable=line-too-long
            # config.bind('<z><z>', 'password-fill')

            # Font
            c.fonts.default_family = "${font.mono}"
            c.fonts.completion.category = "bold ${toString font.size}.0pt ${font.mono}"
            c.fonts.completion.entry = "${toString font.size}.0pt ${font.mono}"
            c.fonts.debug_console = "${toString font.size}.0pt ${font.mono}"
            c.fonts.downloads = "${toString font.size}.0pt ${font.mono}"
            c.fonts.hints = "bold ${toString font.size}.0pt ${font.mono}"
            c.fonts.keyhint = "${toString font.size}.0pt ${font.mono}"
            c.fonts.messages.error = "${toString font.size}.0pt ${font.mono}"
            c.fonts.messages.info = "${toString font.size}.0pt ${font.mono}"
            c.fonts.messages.warning = "${toString font.size}.0pt ${font.mono}"
            c.fonts.prompts = "${toString font.size}.0pt ${font.mono}"
            c.fonts.statusbar = "${toString font.size}.0pt ${font.mono}"
            # c.fonts.tabs = "${toString font.size}.0pt ${font.mono}"
          '';
        };
  };
}
