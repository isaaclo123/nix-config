{ pkgs, ...}: {
  programs.mpv = {
    bindings = {
      "alt+b" = "script-binding sponsorblock/set_segment";
      "shift+b" = "script-binding sponsorblock/submit_segment";
      "h" = "script-binding sponsorblock/upvote_segment";
      "shift+h" = "script-binding sponsorblock/downvote_segment";
      "S" = "screenshot window";
      "g" = "script-message playlist-view-toggle";
    };
  };
}
