"-----------------------------------------------------------------------------------------------------------------------
" Plugins
"-----------------------------------------------------------------------------------------------------------------------
call plug#begin('~/.config/nvim/plugged')

Plug 'Valloric/YouCompleteMe' " Autocomplete
Plug 'christoomey/vim-tmux-navigator' "Allows us to use hjkl in tmux with vim
Plug 'ashiazed/dracula', " Theme
Plug 'francoiscabrol/ranger.vim'  " Ranger integration
Plug 'itchyny/lightline.vim' " Status line
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Install fzf
Plug 'junegunn/fzf.vim' " fzf integration
Plug 'mileszs/ack.vim' " Use ack to grep project directory
Plug 'rbgrouleff/bclose.vim' " Ranger dep for neovim
Plug 'tpope/vim-commentary' " Better commenting commands
Plug 'tpope/vim-surround' " Helps with surrounding text
Plug 'w0rp/ale' " Async linting
Plug 'editorconfig/editorconfig-vim'

" File Type Specific
Plug 'chr4/nginx.vim' " nginx goodness
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }} " preview markdown in browser
Plug 'mattn/emmet-vim' " easier html
Plug 'python-mode/python-mode' " Python awesomeness in vim
Plug 'sheerun/vim-polyglot' " js syntax

call plug#end()

"-----------------------------------------------------------------------------------------------------------------------
" General Settings
"-----------------------------------------------------------------------------------------------------------------------
filetype plugin on " Enable default plugins
set nocompatible " Disable vi-compatible
set hlsearch " Highlight matches to previos search string
set expandtab " In Insert mode: Use the appropriate number of spaces to insert <Tab>.
set tabstop=4 "Number of spaces that a <Tab> counts for
set shiftwidth=0 " Make shiftwidth value the same as tabstop
set nowrap " Turn off text wrapping long lines
set history=1000 " Set number of ':' commands
set splitright " New windows split to the right of current one
set splitbelow " New windows split below the current one
set completeopt-=preview " Hide the preview/scratch window
set path=** " Allow commands like 'gf' to find files
set wildignore=*/app/cache,*/vendor,*/env,*.pyc,*/venv,*/__pycache__,*/venv " Ignore folders
set sessionoptions+=globals " Append global variables to the default session options (Window Names)
set directory=~/.config/nvim/swapdir

" Custom status line
set statusline=
set statusline+=%1*\ %02c\                    " Color
set statusline+=%2*\ »                        " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
set statusline+=%3*\ %<%F\                    " File+path
set statusline+=%2*\«                         " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
set statusline+=%2*\ %=\ %l/%L\ (%02p%%)\     " Rownumber/total (%)

" Set spacing of filetypes
au FileType vim,ledger,html,htmldjango setlocal tabstop=2
au FileType sh,python setlocal tabstop=4
au FileType make setlocal tabstop=4 noexpandtab

" Setup colorscheme
set termguicolors
syntax enable
colorscheme dracula 
" transparency?
hi! Normal ctermbg=NONE guibg=NONE
"
" Set vimdiff colors, make it easier to read
highlight DiffAdd    cterm=BOLD ctermfg=NONE ctermbg=22
highlight DiffDelete cterm=BOLD ctermfg=NONE ctermbg=52
highlight DiffChange cterm=BOLD ctermfg=NONE ctermbg=23
highlight DiffText   cterm=BOLD ctermfg=NONE ctermbg=23

" Highlight lines at 80 mark/120 mark
highlight ColorColumn ctermbg=cyan
au BufEnter *.py let w:m1=matchadd('ColorColumn', '\%89v', 100)
au BufEnter *.py let w:m2=matchadd('Error', '\%89v', 100)
au BufLeave *.py call clearmatches()

let $EditorDir='~/.config/nvim/'

"-----------------------------------------------------------------------------------------------------------------------
" My Shorcuts
"-----------------------------------------------------------------------------------------------------------------------

" use space as leader
let mapleader="\<Space>"

" type jj to get out of insert mode
inoremap jj <ESC>

" Turn off syntax highlighting
nnoremap <leader><leader> :noh<CR>

"Wrap text files
nnoremap <leader>ww :set wrap linebreak nolist<CR>

" Accept current autocomplete suggestion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Faster jumping for linting errors
nnoremap [q :lprev<CR>
nnoremap ]q :lnext<CR>
nnoremap [w :cprev<CR>
nnoremap ]w :cnext<CR>

" Run isort on file
noremap <leader>ei :!isort %<CR>

" Disable arrow keys
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" Open up current file in chrome
nmap <silent> <leader>ch :w !xdg-open %

" User enter to dismiss popup
let g:ycm_key_list_stop_completion = [ '<C-y>', '<Enter>' ]

" Run black on file
noremap <leader>eb :!black %<CR>

" insert dashes
" nnoremap <leader>- :set ri<cr>80A-<esc>81<bar>d$0:set nori<cr>
nnoremap <leader>- :set ri<cr>80A-<esc>81<bar>d$0:set nori<cr>
"-----------------------------------------------------------------------------------------------------------------------


"-----------------------------------------------------------------------------------------------------------------------
" fzf.vim
"-----------------------------------------------------------------------------------------------------------------------
if !empty(glob($EditorDir.'plugged/fzf.vim/plugin/fzf.vim'))
  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>fb :Buffers<CR>
  nnoremap <leader>ft :Tags<CR>
  nnoremap <leader>fm :Marks<CR>
  nnoremap <leader>fc :Commits<CR>
  nnoremap <leader>fg :GFiles?<CR>
  " Enable C-N and C-P to go backwards in history
  let g:fzf_history_dir = $HOME.'/.local/share/fzf-history'
  " [Buffers] Jump to the existing window if possible
  let g:fzf_buffers_jump = 1
endif
"-----------------------------------------------------------------------------------------------------------------------


"-----------------------------------------------------------------------------------------------------------------------
" Ale
"-----------------------------------------------------------------------------------------------------------------------
if !empty(glob($EditorDir.'plugged/ale/autoload/ale.vim'))
  let g:ale_lint_on_enter = 0
  let g:ale_sign_column_always = 1
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_python_mypy_options='--ignore-missing-imports --disallow-untyped-defs'
  let g:ale_history_enabled = 0 
  highlight clear ALEErrorSign
  highlight clear ALEWarningSign
  " Change gutter color
  highlight SignColumn cterm=NONE ctermfg=0 ctermbg=None
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_enter = 0
endif
"-----------------------------------------------------------------------------------------------------------------------



"-----------------------------------------------------------------------------------------------------------------------
" Pymode
"-----------------------------------------------------------------------------------------------------------------------
if !empty(glob($EditorDir.'plugged/python-mode/plugin/pymode.vim'))
  let g:pymode_python = 'python3'
  let g:pymode_run = 1
  let g:pymode_indent = 1
  let g:pymode_motion = 1
  let g:pymode_options_colorcolumn = 0
  let g:pymode_lint = 0
  let g:pymode_rope = 0
  let g:pymode_doc = 0
  let g:pymode_breakpoint = 0
  let g:pymode_lint = 0
  let g:pymode_folding = 0
  let g:pymode_motion = 0 " Disable error when using fzf to switch files
endif
"-----------------------------------------------------------------------------------------------------------------------



"-----------------------------------------------------------------------------------------------------------------------
" Ranger Intergration
"-----------------------------------------------------------------------------------------------------------------------
if !empty(glob($EditorDir.'plugged/ranger.vim/plugin/ranger.vim'))
  let g:ranger_map_keys = 0
  nnoremap <leader>m :Ranger<CR>
  nnoremap <leader>n :RangerWorkingDirectory<CR>
  let g:ranger_replace_netrw = 1 " open ranger when vim open a directory
endif
"-----------------------------------------------------------------------------------------------------------------------



"-----------------------------------------------------------------------------------------------------------------------
" Markdown
"-----------------------------------------------------------------------------------------------------------------------
if !empty(glob($EditorDir.'plugged/vim-markdown/indent/markdown.vim'))
  let g:vim_markdown_folding_disabled=1
endif
"-----------------------------------------------------------------------------------------------------------------------



"-----------------------------------------------------------------------------------------------------------------------
" Ack Searching
"-----------------------------------------------------------------------------------------------------------------------
if !empty(glob($EditorDir.'plugged/ack.vim/plugin/ack.vim'))
  nnoremap <leader>/ :call AckSearch()<CR>
  noremap <leader>ea :Ack <cword><cr>
  function! AckSearch()
    call inputsave()
    let term = input('Search: ')
    call inputrestore()
    if !empty(term)
        execute "Ack! " . term
    endif
  endfunction
  " Setting better default settings
  let g:ackprg =
        \ "ack -s -H --nocolor --nogroup --column --ignore-dir=.venv/ --ignore-dir=.vimcache/ --ignore-dir=migrations/ --ignore-dir=.mypy_cache/ --ignore-dir=htmlcov/ --ignore-dir=.pytest_cache/ --ignore-file=is:.coverage --ignore-file=is:tags --nojs --nocss --nosass"
endif
"-----------------------------------------------------------------------------------------------------------------------



"-----------------------------------------------------------------------------------------------------------------------
" Vim polyglot - turn of Python
"-----------------------------------------------------------------------------------------------------------------------
let g:polyglot_disabled = ['python', 'python-compiler', 'python-indent']
autocmd FileType javascript setlocal formatoptions-=r
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
"-----------------------------------------------------------------------------------------------------------------------
