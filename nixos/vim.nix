{ config, pkgs, ... }:

let
  homedir = (import ./settings.nix).homedir;
  username = (import ./settings.nix).username;
  theme = (import ./settings.nix).theme;
  color = (import ./settings.nix).color;
  opacity = (import ./settings.nix).opacity;
in

# let
#   indentline-color = "#504945";
# in

{
  programs.vim.defaultEditor = true;

  environment.systemPackages =
    let
      zathura-async = (pkgs.writeScript "zathura-async.sh" ''
        #!${pkgs.stdenv.shell}
        zathura ''${*} &
      '');

      vimrc = ''
        " set wildmode=longest,list,full
        " set wildmenu
        set nocp
        set t_Co=256
        filetype plugin indent on
        syntax on
        syn sync fromstart
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

        " vim context
        " let g:context_enabled = 1

        " folding
        set foldmethod=syntax
        set foldlevelstart=1
        let g:vimsyn_folding='af'

        " ncm2
        autocmd BufEnter * call ncm2#enable_for_buffer()

        " IMPORTANT: :help Ncm2PopupOpen for more information
        set completeopt=noinsert,menuone,noselect

        set shortmess+=c
        inoremap <c-c> <ESC>

        inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

        " inoremap <silent> <expr> <CR> ncm2_ultisnips#completed_is_snippet() ?
        "   \ "\<Plug>(ncm2_ultisnips_expand_completed)"
        "   \ : "\<Plug>(AutoPairsReturn)"

        let g:AutoPairsMapCR=0
        inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>\<C-R>=AutoPairsReturn()<CR>", 'n')

        " c-j c-k for moving in snippet
        let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
        let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
        let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
        let g:UltiSnipsRemoveSelectModeMappings = 1

        " This is only necessary if you use "set termguicolors".
        set t_8f=^[[38;2;%lu;%lu;%lum
        set t_8b=^[[48;2;%lu;%lu;%lum

        let g:gruvbox_contrast_dark = 'hard'
        let g:gruvbox_italic=1

        " remove background
        hi Normal guibg=NONE ctermbg=NONE
        autocmd VimEnter * hi Normal guibg=NONE ctermbg=NONE

        set background=${theme.background}
        colorscheme ${theme.name}

        set termguicolors
        if has('nvim')
          " https://github.com/neovim/neovim/wiki/FAQ
          set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
        endif

        set nocompatible

        " disable error sounds
        set noerrorbells visualbell t_vb=
        if has('autocmd')
          autocmd GUIEnter * set visualbell t_vb=
        endif

        " polyglot

        let g:polyglot_disabled = ['py', 'md']

        " rainbow parenthesis
        let g:rainbow_active = 1

        let g:rainbow_conf = {
        \	'guifgs': ['#${color.red}', '#${color.green}', '#${color.yellow}', '#${color.blue}', '#${color.purple}', '#${color.cyan}'],
        \	'ctermfgs': ['1', '2', '3', '4', '5', '6'],
        \}

        " nix folding
        augroup vim_nix
          au!
          au BufNewFile,BufFilePre,BufRead  *.nix setlocal filetype=nix foldmethod=indent foldlevelstart=0
        augroup END

        " mutt mail filetype
        augroup vim_mutt
          au!
          au FileType mail setlocal noautoindent filetype=mail wm=0 tw=78 colorcolumn=78 fo+=aw spell spelllang=en_us
        augroup END

        " calcurse filetype
        augroup vim_calcurse
          au!
          au BufNewFile,BufFilePre,BufRead /tmp/calcurse* set filetype=pandoc
          au BufNewFile,BufFilePre,BufRead ~/.calcurse/notes/* set filetype=pandoc
        augroup END

        " custom keybinds
        inoremap jk <ESC>
        let mapleader = "\<Space>"
        nnoremap <silent> <CR><CR> <Esc>:nohlsearch<CR><Esc>
        nmap <silent> <Leader><Leader> V
        nnoremap <Leader>w :update<CR>
        nnoremap <backspace> :e #<CR>

        " vim easymotion
        let g:EasyMotion_do_mapping = 0 " Disable default mappings
        let g:EasyMotion_smartcase = 1 " Turn on case-insensitive feature
        let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

        " Jump to anywhere you want with minimal keystrokes, with s
        " `s{char}{label}`
        nmap s <Plug>(easymotion-overwin-f)

        " lkjh motions: Line motions
        map <Leader>l <Plug>(easymotion-lineforward)
        map <Leader>j <Plug>(easymotion-j)
        map <Leader>k <Plug>(easymotion-k)
        map <Leader>h <Plug>(easymotion-linebackward)

        " vim-rest-console
        let g:vrc_trigger = '<Leader>r'
        " let g:vrc_split_request_body = 1

        " text pandoc

        augroup vim_pandoc
          au!
          au BufNewFile,BufFilePre,BufRead *.md setlocal filetype=pandoc
          au FileType markdown,pandoc setlocal filetype=pandoc
          au FileType markdown,pandoc setlocal concealcursor=""
          au FileType markdown,txt,pandoc,text map <silent> <Leader>c :TOC<CR>
          au FileType markdown,txt,pandoc,text map <Leader>p :PandocPreview<CR>

          au FileType markdown,txt,pandoc,text let g:table_mode_corner='+'
        augroup END

        augroup vim_text
          au!
          au FileType markdown,txt,pandoc,text setlocal colorcolumn=100
          au FileType markdown,txt,pandoc,text setlocal dictionary+=${pkgs.scowl}/share/dict/wamerican.txt
          au FileType markdown,txt,pandoc,text setlocal spell spelllang=en_us
          au FileType markdown,txt,pandoc,text syntax spell toplevel
        augroup END

        let g:pandoc_preview_pdf_cmd = "${zathura-async}"

        hi clear SpellBad
        hi clear SpellCap
        hi clear SpellLocal
        hi clear SpellRare
        hi SpellBad cterm=underline
        hi SpellCap cterm=underline
        hi SpellLocal cterm=underline
        hi SpellRare cterm=underline
        hi SpellBad gui=undercurl
        hi SpellCap gui=undercurl
        hi SpellLocal gui=underline
        hi SpellRare gui=underline

        " vim-pandoc
        let g:pandoc#folding#fdc = 0
        let g:pandoc#syntax#conceal#use = 1
        let g:pandoc#syntax#conceal#urls = 1
        let g:pandoc#syntax#codeblocks#embeds#use = 1
        let g:pandoc#syntax#codeblocks#embeds#langs = ['c', 'cpp', 'python', 'java', 'sh', 'bash=sh', 'sql']
        let g:pandoc#formatting#mode = 'ha'
        let g:pandoc#formatting#textwidth = 100
        let g:pandoc#after#modules#enabled = ["tablemode", "ultisnips"]

        " python-mode
        let g:pymode_python = 'python3'
        let g:pymode_lint_on_write = 0
        let g:pymode_lint = 0
        let g:pymode_folding = 1
        let g:pymode_indent = 1
        let g:pymode_motion = 1
        let g:pymode_rope = 0

        " coverage
        " autocmd FileType python map <silent> <Leader>c :HighlightCoverage<CR>

        " Vim table mode settings
        let g:table_mode_corner = '+'
        let g:table_mode_corner_corner = '+'
        let g:table_mode_header_fillchar = '='

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
        let g:airline_theme='${theme.name}'
        let g:airline#extensions#wordcount#enabled = 1
        let g:airline#extensions#wordcount#filetypes = ['help', 'markdown', 'rst', 'org', 'text', 'asciidoc', 'tex', 'mail', 'pandoc']

        " ale

        let g:ale_fix_on_save = 1
        let g:ale_completion_enabled = 1
        let g:ale_completion_tsserver_autoimport = 1

        " ale fixers
        let g:ale_fixers = {
        \   '*': ['remove_trailing_lines', 'trim_whitespace'],
        \   'javascript': ['prettier', 'eslint'],
        \   'typescript': ['prettier', 'eslint'],
        \   'vue': ['prettier', 'eslint'],
        \   'rust': ['rustfmt'],
        \}

        let g:ale_linter_aliases = {
        \   'vue': ['vue', 'javascript'],
        \   'typescript': ['typescript', 'javascript'],
        \   'pandoc': ['markdown', 'pandoc'],
        \}

        let g:ale_rust_cargo_use_check=1

        let g:ale_linters = {
        \   'vue': ['eslint'],
        \   'typescript': ['eslint'],
        \   'javascript': ['eslint'],
        \   'html': ['htmlhint'],
        \   'ocaml': ['merlin'],
        \   'pandoc': ['mdl'],
        \   'python': ['flake8'],
        \   'cpp': ['cpplint', 'gcc'],
        \   'java': ['javac'],
        \   'rust': ['rls', 'cargo']
        \}

        map <silent> <Leader>d :ALEDetail<CR>

        " nerdTree settings
        map <silent> <Leader>n :NERDTreeToggle<CR>
        let g:nerdtree_tabs_focus_on_files = 1
        let NERDTreeShowBookmarks=1

        " swapfile
        set swapfile
        set backupdir=${homedir}/.bkp
        set dir=${homedir}/.swp

        " Smart way to move between panes
        map <M-k> <C-w><up>
        map <M-j> <C-w><down>
        map <M-h> <C-w><left>
        map <M-l> <C-w><right>

        set splitbelow
        set splitright

        " recursive pathfinding
        set path+=**

        " indentLine
        let g:indentLine_setColors = 1
        let g:indentLine_color_gui = '#${color.gray}'
        let g:indentLine_concealcursor = 'inc'
        let g:indentLine_conceallevel = 2
        let g:indentLine_fileTypeExclude = ['markdown', 'pandoc']
        let g:indentLine_char_list = ['|', '¦', '┆', '┊']

        " fzf
        set grepprg=rg\ --vimgrep

        set noautochdir
        " autocmd BufEnter * silent! lcd %:p:h

        let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages -g \!"* *" -g "!.git/*"'
        let g:fzf_preview_git_files_command = 'rg --files --hidden --follow --no-messages -g \!"* *" -g "!.git/*"'

        let g:fzf_preview_floating_window_winblend = ${builtins.toString (100 - opacity.inactive-int)}
        let g:fzf_preview_fzf_color_option = "bg+:'#3c3836',bg:'#1d2021',spinner:'#8ec07c',hl:'#83a598',fg:'#bdae93',header:'#83a598',info:'#fabd2f',pointer:'#8ec07c',marker:'#8ec07c',fg+:'#ebdbb2',prompt:'#fabd2f',hl+:'#83a598'"
        let g:fzf_preview_use_dev_icons = 1
        let g:fzf_preview_filelist_postprocess_command = 'xargs -d "\n" ls -U --color'      " Use dircolors

        " :cd %:p:h<CR>
        nnoremap <M-c> :cd %:p:h<CR>:pwd<CR>

        nmap <silent> <C-t> :FzfPreviewProjectFiles<CR>
        nmap <silent> <C-p> :FzfPreviewDirectoryFiles<CR>
        nmap <silent> <Leader>/ :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query="'"<CR>
        nmap <Leader>g :<C-u>FzfPreviewProjectGrep<Space>
        nmap <silent> <Leader>b :<C-u>FzfPreviewAllBuffers<CR>

        nmap <Leader>f [fzf-p]
        xmap <Leader>f [fzf-p]

        nnoremap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResources project_mru git<CR>
        nnoremap <silent> [fzf-p]gs    :<C-u>FzfPreviewGitStatus<CR>
        nnoremap <silent> [fzf-p]b     :<C-u>FzfPreviewBuffers<CR>
        nnoremap <silent> [fzf-p]B     :<C-u>FzfPreviewAllBuffers<CR>
        nnoremap <silent> [fzf-p]o     :<C-u>FzfPreviewFromResources buffer project_mru<CR>
        nnoremap <silent> [fzf-p]<C-o> :<C-u>FzfPreviewJumps<CR>
        nnoremap <silent> [fzf-p]g;    :<C-u>FzfPreviewChanges<CR>
        nnoremap <silent> [fzf-p]/     :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query="'"<CR>
        nnoremap <silent> [fzf-p]*     :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
        nnoremap          [fzf-p]gr    :<C-u>FzfPreviewProjectGrep<Space>
        xnoremap          [fzf-p]gr    "sy:FzfPreviewProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', "", 'g'), '/', '\\/', 'g')<CR>"
        nnoremap <silent> [fzf-p]t     :<C-u>FzfPreviewBufferTags<CR>
        nnoremap <silent> [fzf-p]q     :<C-u>FzfPreviewQuickFix<CR>
        nnoremap <silent> [fzf-p]l     :<C-u>FzfPreviewLocationList<CR>

        " vim gutentags
        let g:airline#extensions#gutentags#enabled = 1
        let g:gutentags_ctags_tagfile = ".git/tags"

        " Nvim-R
        augroup nvim_r
          au!
          au BufNewFile,BufFilePre,BufRead *.{r,R} set filetype=r

          au Filetype R,r map <Leader>r <Plug>RSendFile
          au Filetype R,r nmap , <Plug>RDSendLine
          " remapping selection :: send multiple lines
          au Filetype R,r vmap , <Plug>RDSendSelection
          " remapping selection :: send multiple lines + echo lines
          au Filetype R,r vmap ,e <Plug>RESendSelection
        augroup END

        " typescript
        let g:typescript_indent_disable = 1

        augroup tsx
          au!
          au FileType typescript setlocal indentkeys+=0
        augroup END
      ''; in

      let system_vim = (pkgs.neovim.override {
        vimAlias = true;

        withPython = true;
        withPython3 = true;

        configure = {
          packages.myVimPackage = {

            start = with pkgs.vimPlugins; [
              (pkgs.vimUtils.buildVimPlugin {
                name = "vim-wordmotion";
                src = pkgs.fetchFromGitHub {
                  owner = "chaoren";
                  repo = "vim-wordmotion";
                  rev = "4c8c4ca0165bc45ec269d1aa300afc36edee0a55";
                  sha256 = "1dnvryzqrf9msr81qlmcdf660csp43h19mbx56dnadpsyzadx6vm";
                };
              })

              (pkgs.vimUtils.buildVimPlugin {
                name = "pandoc-preview";
                src = pkgs.fetchFromGitHub {
                  owner = "lingnand";
                  repo = "pandoc-preview.vim";
                  rev = "7f3506d3d7037ed8c06303b3fb035cec9f987fa0";
                  sha256 = "0v5g25cf58lic06ygnm2gr3c9z4wdmzjq6k8h02xwrmwcfp76r6r";
                };
              })

              (pkgs.vimUtils.buildVimPlugin {
                name = "Nvim-R";
                src = pkgs.fetchurl {
                  url = "https://github.com/jalvesaq/Nvim-R/archive/v0.9.13.tar.gz";
                  sha256 = "0rz836gwsfp4n1vskcs45z1bign5cp0r1jzw1f6xwfqbg3r35lfl";
                };
                buildInputs = with pkgs; [ which vim zip ];
              })

              (pkgs.vimUtils.buildVimPlugin {
                name = "fzf-preview-vim";
                src = pkgs.fetchFromGitHub {
                  owner = "yuki-ycino";
                  repo = "fzf-preview.vim";
                  rev = "765b9b3b29fd625aa76f5a517f83309269fdfea0";
                  sha256 = "1h6bd38727dkm1rpkfb7ag9ii8ps5j998m1zrdpr71avzfi56r7j";
                };
              })

              (pkgs.vimUtils.buildVimPlugin {
                name = "vim-rest-console";
                src = pkgs.fetchFromGitHub {
                  owner = "diepm";
                  repo = "vim-rest-console";
                  rev = "7b407f47185468d1b57a8bd71cdd66c9a99359b2";
                  sha256 = "1x7qicd721vcb7zgaqzy5kgiqkyj69z1lkl441rc29n6mwncpkjj";
                };
              })

              (pkgs.vimUtils.buildVimPlugin {
                name = "ncm2-racer";
                src = pkgs.fetchFromGitHub {
                  owner = "ncm2";
                  repo = "ncm2-racer";
                  rev = "e3aec0836ea1ff1b820e937f9c6463eb015fa784";
                  sha256 = "03vd252qm6b3isd45jz7wah3p9sm73pf4gxngwsfb1hc1hn7c1cf";
                };
              })

              fzf-vim
              vim-gutentags

              gruvbox
              vim-startify
              vim-devicons
              vim-airline

              indentLine
              editorconfig-vim
              vim-polyglot
              vim-nix
              ale

              vim-pandoc
              vim-pandoc-syntax
              vim-pandoc-after

              vim-speeddating
              vim-easymotion
              vim-css-color
              vim-table-mode
              auto-pairs
              python-mode

              nerdtree

              nvim-yarp
              ncm2
              ncm2-path
              ncm2-ultisnips
              ncm2-bufword
              ncm2-jedi

              rust-vim

              vim-snippets
              vim-unimpaired
              vim-surround
              direnv-vim
              rainbow

              ansible-vim

              haskell-vim
              vim-hindent

              typescript-vim
            ];

            opt = [ ];
          };

          customRC = vimrc;
        };
      }); in
      let system_vimdiff = (pkgs.writeShellScriptBin "vimdiff" ''
        vim -d "$@"
      ''); in
      with pkgs; [
        (system_vim)
        (system_vimdiff)
        universal-ctags
        scowl

        # for fzf
        ripgrep

        mdl

        unstable.travis

        nodePackages.prettier
        nodePackages.javascript-typescript-langserver
        # nodePackages.eslint
      ];

  home-manager.users."${username}" = {
    home.file = {
      ".editorconfig".text = ''
        root = true

        [*]
        end_of_line = lf
        charset = utf-8
        trim_trailing_whitespace = true
        insert_final_newline = false

        [Makefile]
        indent-style = tab

        [makefile]
        indent-style = tab

        [*.{py,kv}]
        indent-style = space
        indent_size = 4
        max_line_length = 80

        [*.md]
        indent-style = space
        indent_size = 4
        max_line_length = 100

        [*.{ml,li}]
        indent-style = space
        indent_size = 2
        max_line_length = 70

        [*.{c,cc,h}]
        indent-style = space
        indent_size = 2
        max_line_length = 80

        [*.{js,css,scss,html,json,jsx,tsx,ts}]
        max_line_length = 100
        indent-style = space
        indent_size = 2

        [**.min.js]
        indent_style = ignore
        insert_final_newline = ignore
      '';

      ".mdlrc".text = ''
        style "${homedir}/.mdl_style.rb"
      '';

      ".mdl_style.rb".text = ''
        all
        exclude_rule 'MD007'
        exclude_rule 'MD009'
        exclude_rule 'MD024'
        exclude_rule 'MD029'
        exclude_rule 'MD036'
        exclude_rule 'MD041'
        exclude_rule 'MD011'
        exclude_rule 'MD034'
        exclude_rule 'MD039'

        rule 'MD013', :line_length => 100
      '';
    };
  };
}
