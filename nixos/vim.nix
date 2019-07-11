{ config, pkgs, ... }:

{
  environment = let system_vim = (pkgs.neovim.override {
    vimAlias = true;
    configure = {
      customRC = ''
        set wildmode=longest,list,full
        set wildmenu
        set nocp
        set t_Co=256
        filetype plugin indent on
        syntax on
        " syn sync fromstart
        syntax sync minlines=200
        set encoding=utf-8
        set number
        set noshowmode
        set cursorline
        set hlsearch
        set incsearch
        set noim
        set ic
        set smartcase
        set smartindent
        set lazyredraw
        set ttyfast
        set mouse=a
        set clipboard=unnamed
        set cmdheight=1
        set so=999

        set tabstop=4
        set softtabstop=0
        set expandtab
        set shiftwidth=4
        set smarttab

        " deoplete
        let g:deoplete#enable_at_startup = 1

        " This is only necessary if you use "set termguicolors".
        set t_8f=^[[38;2;%lu;%lu;%lum
        set t_8b=^[[48;2;%lu;%lu;%lum

        set background=dark
        colorscheme Atelier_SulphurpoolDark

        set termguicolors
        " set t_Co=256
        if has('nvim')
          " https://github.com/neovim/neovim/wiki/FAQ
          set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
        endif

        set nocompatible

        " largefile
        let g:LargeFile=10

        " disable error sounds
        set noerrorbells visualbell t_vb=
        if has('autocmd')
          autocmd GUIEnter * set visualbell t_vb=
        endif

        " folding
        set foldmethod=syntax
        set foldnestmax=1
        " set foldlevelstart=1
        " set nofoldenable
        let g:vimsyn_folding='af'

        " calcurse markdown
        autocmd BufRead,BufNewFile /tmp/calcurse* set filetype=markdown
        autocmd BufRead,BufNewFile ~/.calcurse/notes/* set filetype=markdown

        " mutt mail filetype
        autocmd BufNewFile,BufRead /tmp/mutt* set noautoindent filetype=mail wm=0 tw=78 colorcolumn=78 fo+=aw
        autocmd BufNewFile,BufRead ~/.cache/mutt.html set noautoindent filetype=mail wm=0 tw=78 colorcolumn=78 fo+=aw

        " indentLine
        "let g:indentLine_setColors = 0
        let g:indentLine_char = '▏'
        let g:indentLine_color_term = 19
        let g:indentLine_concealcursor = ' '
        " let g:indentLine_leadingSpaceEnabled = 1
        " let g:indentLine_leadingSpaceChar = '-'

        " omnifunc
        set omnifunc=syntaxcomplete#Complete
        " let b:vcm_tab_complete = 'omni'

        " custom keybinds
        inoremap jk <ESC>
        let mapleader = "\<Space>"
        nnoremap <silent> <CR><CR> <Esc>:nohlsearch<CR><Esc>
        nmap <silent> <Leader><Leader> V
        nnoremap <Leader>w :update<CR>
        " nnoremap <Leader>r :e<CR>
        nnoremap <backspace> :e #<CR>

        " vim easymotion
        let g:EasyMotion_do_mapping = 0 " Disable default mappings
        let g:EasyMotion_smartcase = 1 " Turn on case-insensitive feature
        " let g:EasyMotion_use_smartsign_us = 1 " Smartsign (type `3` and match `3`&`#`)
        let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

        " Jump to anywhere you want with minimal keystrokes, with s
        " `s{char}{label}`
        nmap s <Plug>(easymotion-overwin-f)
        " or
        " `s{char}{char}{label}`
        " Need one more keystroke, but on average, it may be more comfortable.
        " nmap s <Plug>(easymotion-overwin-f2)

        " lkjh motions: Line motions
        map <Leader>l <Plug>(easymotion-lineforward)
        map <Leader>j <Plug>(easymotion-j)
        map <Leader>k <Plug>(easymotion-k)
        map <Leader>h <Plug>(easymotion-linebackward)

        " Gif config
        " map  / <Plug>(easymotion-sn)
        " omap / <Plug>(easymotion-tn)

        " These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
        " Without these mappings, `n` & `N` works fine. (These mappings just provide
        " different highlight method and have some other features )
        " map  n <Plug>(easymotion-next)
        " map  N <Plug>(easymotion-prev)

        " spelling
        " set dictionary+=/usr/share/dict/words

        autocmd FileType pandoc set colorcolumn=100
        autocmd FileType markdown,txt,pandoc,text setlocal complete+=k
        autocmd FileType markdown,txt,pandoc,text syntax spell toplevel
        autocmd FileType markdown,txt,pandoc,text let b:table_mode_corner = '+'
        autocmd FileType markdown,txt,pandoc,text map <silent> <leader>c :TOC<CR>
        autocmd FileType markdown,txt,pandoc,text map <leader>p :PandocPreview<cr>
        au BufRead *.md setlocal spell spelllang=en_us

        hi clear SpellBad
        hi clear SpellCap
        hi clear SpellLocal
        hi clear SpellRare
        hi SpellBad cterm=underline
        hi SpellCap cterm=underline
        hi SpellLocal cterm=underline
        hi SpellRare cterm=underline

        " vim-pandoc
        let g:tex_conceal="abdgm"
        " let g:pandoc#syntax#style#underline_special = 1
        let g:pandoc#folding#fdc = 0
        let g:pandoc#syntax#conceal#use = 1
        let g:pandoc#syntax#conceal#urls = 1
        let g:pandoc#syntax#codeblocks#embeds#use = 1
        " let g:pandoc#syntax#codeblocks#embeds#langs = ['c', 'html', 'javascript', 'asm', 'python', 'sh', 'java']
        let g:pandoc#syntax#codeblocks#embeds#langs = ['c', 'cpp', 'python', 'java', 'sh', 'bash=sh']
        let g:pandoc#formatting#mode = 'ha'
        let g:pandoc#formatting#textwidth = 99
        let g:indentLine_fileTypeExclude = ['pandoc']

        " vim pandoc preview
        let g:pandoc_preview_pdf_cmd = "/home/isaac/bin/zathura-async"

        " python-mode
        let g:pymode_python = 'python3'
        let g:pymode_lint_on_write = 0
        let g:pymode_lint = 0
        let g:pymode_folding = 1
        let g:pymode_indent = 1
        let g:pymode_motion = 1
        let g:pymode_rope = 0

        " coverage
        " autocmd FileType python map <silent> <leader>c :HighlightCoverage<CR>

        " Vim table mode settings
        let g:table_mode_corner = '+'
        let g:table_mode_corner_corner = '+'
        let g:table_mode_header_fillchar ='='

        function! s:isAtStartOfLine(mapping)
            let text_before_cursor = getline('.')[0 : col('.')-1]
            let mapping_pattern = '\V' . escape(a:mapping, '\')
            let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', ' ', ' '), '\')
            return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
        endfunction

        inoreabbrev <expr> <bar><bar>
                    \ <SID>isAtStartOfLine('\|\|') ?
                    \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
        inoreabbrev <expr> __
                    \ <SID>isAtStartOfLine('__') ?
                    \ '<c-o>:silent! TableModeDisable<cr>' : '__'

        " airline settings
        set laststatus=2
        let g:airline_powerline_fonts = 0
        let g:airline#extensions#ale#enabled = 1
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#show_buffers = 0
        let g:airline_theme='Atelier_SulphurpoolDark'
        let g:airline#extensions#wordcount#enabled = 1
        let g:airline#extensions#wordcount#filetypes = ['help', 'markdown', 'rst', 'org', 'text', 'asciidoc', 'tex', 'mail', 'pandoc']

        " ale

        " ale fixers
        let g:ale_fixers = {
                    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
                    \   'javascript': ['eslint'],
                    \}

        " let g:ale_lint_on_save = 1
        " let g:ale_completion_enabled = 1
        " let g:ale_lint_on_text_changed = 'never'
        " let g:ale_lint_on_enter = 0
        "
        " Set this variable to 1 to fix files when you save them.
        let g:ale_fix_on_save = 1
        let g:ale_completion_enabled = 1
        " let g:ale_lint_on_text_changed = 'never'
        " let g:ale_lint_on_enter = 0

        let g:ale_linter_aliases = {
                    \   'vue': ['vue', 'javascript'],
                    \   'pandoc': ['markdown', 'pandoc'],
                    \}

        let g:ale_linters = {
                    \   'vue': ['eslint'],
                    \   'html': ['htmlhint'],
                    \   'ocaml': ['merlin'],
                    \   'pandoc': ['mdl'],
                    \   'python': ['pylint'],
                    \   'cpp': ['cpplint', 'gcc'],
                    \   'java': ['javac']
                    \}

        " let g:ale_cpp_cpplint_options = '--root=..'

        " nerdTree settings
        map <silent> <leader>n :NERDTreeToggle<CR>
        let g:nerdtree_tabs_focus_on_files = 1
        let NERDTreeShowBookmarks=1

        " swapfile
        set swapfile
        set dir=/home/isaac/.swp

        " split navigation
        nnoremap <C-J> <C-W><C-J>
        nnoremap <C-K> <C-W><C-K>
        nnoremap <C-L> <C-W><C-L>
        nnoremap <C-H> <C-W><C-H>

        set splitbelow
        set splitright

        " recursive pathfinding
        set path+=**

      '';
      plug.plugins = let vim-base2tone-theme = pkgs.vimUtils.buildVimPlugin {
        name = "vim-base2tone-theme";
        src = pkgs.fetchFromGitHub {
          owner = "atelierbram";
          repo = "vim-colors_atelier-schemes";
          rev = "ccdd1558b172da6928db7d27d43da75df0444ed9";
          sha256 = "14iwc9g88b6p4pjigvc7rd2x8f5xcz1ajd74i7l7i71ys8dpdcga";
        };
      }; in
      with pkgs.vimPlugins; [
        (vim-base2tone-theme)
        editorconfig-vim
        vim-polyglot
        vim-nix
        ale
        vim-airline
        vim-pandoc
        vim-pandoc-syntax
        vim-speeddating
        vim-easymotion
        vim-css-color
        nerdtree
        vim-table-mode
        auto-pairs
        python-mode
        ctrlp
        deoplete-nvim
      ];
    };
  });
  in
  {
    variables = {
      EDITOR = "vim";
    };

    systemPackages = with pkgs; [
      (system_vim)
      neovim
      nvi
      universal-ctags
    ];
  };
}
