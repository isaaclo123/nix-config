{ pkgs, ...}: {
  programs.nixvim = {
    plugins.csvview = {
      enable = true;
      autoLoad = true;
      settings = {
          parser = { comments = [ "#" "//" ]; };
          keymaps = {
            textobject_field_inner = { __raw = "{ 'if', mode = { 'o', 'x' } }"; };
            textobject_field_outer = { __raw = "{ 'af', mode = { 'o', 'x' } }"; };
            # Excel-like navigation:
            # Use <Tab> and <S-Tab> to move horizontally between fields.
            # Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
            # Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
            jump_next_field_end = { __raw = "{ '<Tab>', mode = { 'n', 'v' } }"; };
            jump_prev_field_end = {__raw = "{ '<S-Tab>', mode = { 'n', 'v' } }"; };
            jump_next_row = { __raw  = "{ '<Enter>', mode = { 'n', 'v' } }"; };
            jump_prev_row = { __raw = "{ '<S-Enter>', mode = { 'n', 'v' } }"; };
          };
        };
      };
    };
}
