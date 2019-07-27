{ pkgs, ... }:

let
  unstable = import <unstable> {};
in

let homedir = builtins.getEnv "HOME"; in
# let configdir = "${homedir}/.nixpkgs"; in

let ncmpcpp-config = (pkgs.writeText "config" ''
  visualizer_fifo_path = "/tmp/mpd.fifo"
  visualizer_output_name = "my_fifo"
  visualizer_sync_interval = "30"
  visualizer_in_stereo = "yes"
  visualizer_type = "wave_filled"
  " visualizer_look = "▄▄"
  mpd_music_dir = "~/Music"
  display_bitrate = "yes"
  playlist_display_mode = "classic" (classic/columns)
  mouse_support = "yes"
  cyclic_scrolling = "yes"
  mouse_list_scroll_whole_page = "no"
  lines_scrolled = 1
  song_library_format = "{%n > }{%t}|{%f}"
  " progressbar_look = "▄▄ "
  " selected_item_prefix = " √ "
  titles_visibility = "no"
  header_visibility = "no"
  statusbar_visibility = "no"
  browser_display_mode = "classic" (classic/columns)
  discard_colors_if_item_is_selected = "no"
  song_window_title_format = "%a - %t"
  search_engine_display_mode = "columns" (classic/columns)
  follow_now_playing_lyrics = "yes"
  user_interface = "alternative"
  autocenter_mode = "yes"
  centered_cursor = "yes"
  volume_change_step = 5
''); in

let ncmpcpp-bindings = (pkgs.writeText "bindings" ''
  # the t key isn't used and it's easier to press than /, so lets use it
  def_key "t"
      find
  def_key "t"
      find_item_forward

  def_key "+"
      show_clock
  def_key "="
      volume_up

  def_key "j"
      scroll_down
  def_key "k"
      scroll_up

  def_key "ctrl-u"
      page_up
  #push_characters "kkkkkkkkkkkkkkk"
  def_key "ctrl-d"
      page_down
  #push_characters "jjjjjjjjjjjjjjj"

  def_key "h"
      previous_column
  def_key "l"
      next_column

  def_key "."
      show_lyrics

  def_key "n"
      next_found_item
  def_key "N"
      previous_found_item

  # not used but bound
  def_key "J"
      move_sort_order_down
  def_key "K"
      move_sort_order_up
''); in

{
  home.packages = with pkgs; [
    # music
    ncmpcpp
    # mpd
    mpc_cli
    unstable.audacity
  ];

  services.mpd = {
    enable = true;
    dataDir = "${homedir}/.mpd";
    musicDirectory = "${homedir}/Music";
  };

  xdg.configFile = {
    "ncmpcpp/config".source = ncmpcpp-config;
    "ncmpcpp/bindings".source = ncmpcpp-bindings;
  };
}
