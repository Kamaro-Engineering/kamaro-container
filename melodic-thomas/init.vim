" vim: foldmethod=marker
" Base config with sane defaults
" should be kept compatible with vim, nvim and embedded nvim

" Settings {{{
set nocompatible

"FIXME consider using $XDG_CONFIG_HOME/nvim
set runtimepath^=~/.vim runtimepath+=~/.vim/after

filetype plugin indent on
syntax on

set title
set ruler
set showcmd
set incsearch
set nolangremap
set autoindent
set backspace=indent,eol,start
set mouse=a
set number
set relativenumber
set hidden
set tildeop
if has("nvim")
  set inccommand=split
endif

set belloff=all
set vb
set t_vb=

set undofile
set undodir^=~/.vim/tmp
set backupskip+=/dev/shm/*
"swap files
set dir^=~/.vim/swap,~/.vim/tmp
augroup UNDOFILE
  au!
  au BufWritePre /tmp/* setlocal noundofile
  au BufWritePre /dev/shm/* setlocal noundofile
  au BufWritePre /tmp/* setlocal noswapfile
  au BufWritePre /dev/shm/* setlocal noswapfile
augroup END

set shiftwidth=2
set expandtab
set smarttab
set tabstop=4

set textwidth=90

set wrap
set scrolloff=2
set sidescrolloff=5
set sidescroll=1
set listchars=extends:►,precedes:◄
inoremap <C-A> <C-O>ze

set wildmenu
set wildmode=longest:full,full

set foldmethod=marker

set spelllang=de,en_us

let mapleader = " "
let maplocalleader = " "

set guioptions-=m guioptions-=T guioptions-=L

augroup JUMPTOLASTCURSORPOS
  au!
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

" }}}

" Commands {{{

"I am bad at typing
command! W :w
command! Wq :wq
command! WQ :wq
command! Q :q
command! Qa :qa
command! QA :qa

command! CopyFilename :let @+=expand("%") | echo "Copied \"" . expand("%") . "\""
command! CopyPath :let @+=expand("%:h") . "/" | echo "Copied \"" . expand("%:h") . "/\""

command! Retrail :%s/\s\+$//e | let @/ = ""

command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

command! FoldFunc set foldmethod=syntax | set foldcolumn=1

" }}}

" Mappings {{{

" Use <C-S> for window commands to solve conflict with terminal <C-W>
map <C-S> <C-W>
imap <C-S> <C-O><C-W>
tnoremap <C-S> <C-\><C-N><C-W>

tnoremap <C-N> <C-\><C-N>

"buffer switching
noremap gb :bnext<CR>
noremap gB :bprevious<CR>

"Do not use Ex-mode, open command-line window instead
noremap <silent> Q q:

" Better QWERTZ support
map <silent> ö [
map <silent> ä ]
map <silent> Ö {
map <silent> Ä }
map <silent> ü <c-]>

" clear last search pattern
map <silent> <leader>x :let @/ = ""<CR>

" completion menu mappings
inoremap <silent><expr> <Tab> pumvisible() ? "\<Down>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<Up>" : "\<S-Tab>"
inoremap <silent><expr> <C-J> pumvisible() ? "\<C-N>" : "\<C-J>"
inoremap <silent><expr> <C-K> pumvisible() ? "\<C-P>" : "\<C-K>"
inoremap <silent><expr> <C-L> pumvisible() ? "\<C-Y>" : "\<C-L>"

" }}}

" Filetype specifics {{{
augroup FILETYPE_CONF
  autocmd!

  " OpenGL syntax settings
  au BufNewFile,BufRead,BufEnter *.frag,*.vert,*.fp,*.glsl setf glsl
  " ROS launch files
  au BufNewFile,BufRead,BufEnter *.launch setf xml
  au BufNewFile,BufRead,BufEnter *.test setf xml

  " Makefiles require tabs
  au FileType make setlocal noexpandtab
  " Yamls default autoindent sucks
  au FileType yaml setlocal indentkeys-=0# indentkeys-=<:>
  "Latex
  au FileType tex setlocal spell
  "Comments in json
  au FileType json syntax match Comment +\/\/.\+$+

augroup END
" }}}
