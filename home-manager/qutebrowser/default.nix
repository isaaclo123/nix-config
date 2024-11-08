{ pkgs, ...}: {
  xdg.mimeApps = {
    enable = true;
    
    defaultApplications = {
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
    };
  };

  home.sessionVariables = {
    BROWSER = "qutebrowser";
  };

  # clear cookies
  home.packages = [ pkgs.haskellPackages.bisc ];

  programs.qutebrowser = 
    let user-content-css = pkgs.fetchurl {
      url = "https://www.gozer.org/mozilla/ad_blocking/css/ad_blocking.css";
      sha256 = "1slwkawdfxzb1mvs7qp4hb833nizj5kldsk8agwiq54m6r7ykyw4";
    }; in
  {
    enable = true;
    enableDefaultBindings = true;

    greasemonkey = [
      # (pkgs.fetchurl {
      #   url = "https://update.greasyfork.org/scripts/489265/YouTube%20Ad%20Blocker.user.js";
      #   sha256 = "0sw5l9vwdizc0p6f2r0ij2g6g3kbv44yry08mrrzwvkccdw18xa6";
      #   name = "youtube-adblocker.js";
      # })
      (pkgs.fetchurl {
        url = "https://update.greasyfork.org/scripts/453320/Simple%20Sponsor%20Skipper.user.js";
        sha256 = "1r4adaf2ys138xj6maa1n3xhksghd868y564yqahc48mccd74rsa";
        name = "youtube-sponsorblock.js";
      })
      (pkgs.writeText "youtube-adblock.js" ''$builtins.readFile {./youtube-adblock.js}'')
    ];

    settings = {
      "content.user_stylesheets" = ["${user-content-css}"];
      "content.blocking.method" = "both";
      "colors.webpage.darkmode.enabled" = true;
      "colors.webpage.darkmode.algorithm" = "lightness-cielab";
      "colors.webpage.darkmode.contrast" = 0.5;
      "colors.webpage.darkmode.policy.images" = "never";
      #"colors.webpage.darkmode.policy.page" = "smart";
      "colors.webpage.darkmode.threshold.foreground" = 150;
      "colors.webpage.darkmode.threshold.background" = 205;
      "colors.webpage.preferred_color_scheme" = "dark";
      "content.blocking.adblock.lists" = [
        "https://easylist.to/easylist/easylist.txt"
        "https://easylist.to/easylist/easyprivacy.txt"
        "https://easylist.to/easylist/fanboy-annoyance.txt"
        "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
      ];
      "tabs.last_close" = "close";
      "tabs.new_position.unrelated" = "next";

      "content.autoplay" = false;
      "content.javascript.enabled" = true;
      "content.javascript.can_open_tabs_automatically" = true;
    };

    searchEngines = {
      "DEFAULT" = "https://duckduckgo.com/?q={}";
      "n" = "https://search.nixos.org/flakes?channel=23.11&from=0&size=50&sort=relevance&type=packages&query={}";
      # "y" = "https://www.youtube.com/results?search_query={}";
      "y" = "https://yewtu.be/search?q={}";
      "w" = "https://en.wikipedia.org/w/index.php?search={}&title=Special:Search";
      "g" = "https://www.google.com/search?q={}";
      "r" = "https://doc.rust-lang.org/std/index.html?search={}";
    };

    aliases = {
      "tor-cycle" = "config-cycle -t -p content.proxy http://0.0.0.0:8118/ system";
      "qute-pass" = "spawn --userscript ${pkgs.qutebrowser}/share/qutebrowser/userscripts/qute-pass -d 'wofi --show=dmenu'";
      "password-fill" = "spawn --userscript ${pkgs.qutebrowser}/share/qutebrowser/userscripts/password_fill";
    };

    keyBindings.normal = {
      "tt" = "tor-cycle";
      "xx" = "config-cycle statusbar.show always never;; config-cycle tabs.show always switching";
      "xt" = "config-cycle tabs.show always switching";
      "xb" = "config-cycle statusbars.show always never";
      "dd" = "tab-close";
      "J" = "tab-prev";
      "K" = "tab-next";
      "gT" = "tab-prev";
      "gt" = "tab-next";
      "<Ctrl-E>" = "scroll down";
      "<Ctrl-Y>" = "scroll up";
      ";p" = "hint images";
      ";P" = "hint images tab";
      "I" = "set-cmd-text -s :open --private";
      ";I" = "hint --rapid links run :open --private {hint-url}";

      "m" = "spawn mpv {url}";
      "M" = "hint links spawn mpv {hint-url}";

      "<Alt-9>" = "buffer 9";
      "<Alt-0>" = "buffer 10";
      "<Alt-q>" = "buffer 11";
      "<Alt-w>" = "buffer 12";
      "<Alt-e>" = "buffer 13";
      "<Alt-r>" = "buffer 14";
      "<Alt-t>" = "buffer 15";
      "<Alt-y>" = "buffer 16";
      "<Alt-u>" = "buffer 17";
      "<Alt-i>" = "buffer 18";
      "<Alt-o>" = "buffer 19";
      "<Alt-p>" = "buffer 20";
      "<Alt-g>" = "set-cmd-text -s :buffer";

      "<z><l>" = "qute-pass";
      "<z><u><l>" = "qute-pass --username-only";
      "<z><p><l>" = "qute-pass --password-only";
      "<z><o><l>" = "qute-pass --otp-only";
      "<z><z>" = "password-fill";
    };

    extraConfig = ''
      config.unbind("d", mode='normal')
      config.unbind("D", mode='normal')
      config.unbind(";i", mode='normal')
      config.unbind(";I", mode='normal')

      # c.fonts.default_family = "Operator Mono Medium"


      c.fonts.web.family.cursive = "Operator Mono Italic"
      c.fonts.web.family.fantasy = "Operator Mono Italic"
      c.fonts.web.family.fixed = "Operator Mono"
      c.fonts.web.family.sans_serif = "DejaVu Sans"
      c.fonts.web.family.serif = "DejaVu Serif"
      c.fonts.web.family.standard = "DejaVu Sans"

      config.set('content.headers.user_agent',
           'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
           'accounts.google.com')
    '';
  };
}
