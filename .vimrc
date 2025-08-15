" ========================
" === BASIC SETTINGS ===
" ========================
set nocompatible
set number
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set mouse=a
syntax enable
set cursorline
set showmatch
set ignorecase
set smartcase
set incsearch
set hlsearch
set clipboard=unnamed,unnamedplus  " Enhanced clipboard integration
set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0
let mapleader = " "

" ========================
" === KEY MAPPINGS ===
" ========================
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>c :nohlsearch<CR>
nnoremap <leader>/ :Commentary<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
" Buffer management
nnoremap <leader>b :buffers<CR>:buffer<Space>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>ba :enew<CR>
" Yank to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
" vim-surround mappings
" Add surrounding (e.g., <leader>sa q for single quotes, <leader>sa p for parentheses)
nnoremap <leader>saq ysiw'
nnoremap <leader>sad ysiw"
nnoremap <leader>sap ysiw(
nnoremap <leader>sab ysiw[
nnoremap <leader>sac ysiw{
nnoremap <leader>sat ysiwt
vnoremap <leader>saq S'
vnoremap <leader>sad S"
vnoremap <leader>sap S(
vnoremap <leader>sab S[
vnoremap <leader>sac S{
vnoremap <leader>sat St
" Change surrounding (e.g., <leader>sc qd to change single to double quotes)
nnoremap <leader>scqd cs'"
nnoremap <leader>scdq cs"'
nnoremap <leader>scqp cs'(
nnoremap <leader>scpq cs('
nnoremap <leader>scdp cs"(
nnoremap <leader>scpd cs("
" Delete surrounding (e.g., <leader>sd q to delete single quotes)
nnoremap <leader>sdq ds'
nnoremap <leader>sdd ds"
nnoremap <leader>sdp ds(
nnoremap <leader>sdb ds[
nnoremap <leader>sdc ds{
nnoremap <leader>sdt dst
" Airline: show available options
nnoremap <leader>at :AirlineTheme<CR>

" ========================
" === VIM-PLUG INSTALL ===
" ========================
call plug#begin('~/.vim/plugged')
" Themes
Plug 'NLKNguyen/papercolor-theme'
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tomasr/molokai'
Plug 'ayu-theme/ayu-vim'
Plug 'rakr/vim-one'
Plug 'sainnhe/everforest'
Plug 'sainnhe/sonokai'
Plug 'arcticicestudio/nord-vim'
" File explorer (lazy-loaded)
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Commenting
Plug 'tpope/vim-commentary'
" Auto-pairs
Plug 'jiangmiao/auto-pairs'
" Surround
Plug 'tpope/vim-surround'
call plug#end()

" ========================
" === AIRLINE CONFIG ===
" ========================
let g:airline_powerline_fonts = 1  " Enable powerline fonts for fancy symbols

" ========================
" === THEME CHOOSER ===
" ========================
let g:themes = [
  \ {'name': 'gruvbox', 'airline': 'gruvbox'},
  \ {'name': 'onedark', 'airline': 'onedark'},
  \ {'name': 'dracula', 'airline': 'dracula'},
  \ {'name': 'molokai', 'airline': 'molokai'},
  \ {'name': 'ayu', 'airline': 'ayu'},
  \ {'name': 'one', 'airline': 'one'},
  \ {'name': 'everforest', 'airline': 'everforest'},
  \ {'name': 'sonokai', 'airline': 'sonokai'},
  \ {'name': 'nord', 'airline': 'nord'},
  \ {'name': 'PaperColor', 'airline': 'papercolor'},
  \ ]

let s:theme_file = expand('~/.vim_last_theme')
if filereadable(s:theme_file)
  let g:current_theme_index = str2nr(readfile(s:theme_file)[0])
else
  let g:current_theme_index = 0
endif

function! SetTheme(idx, ...)
  let silent_mode = get(a:, 1, 0)
  let theme = g:themes[a:idx]
  if !silent_mode
    echohl WarningMsg
    echom "Switching to theme: " . theme.name
    echohl None
  endif
  try
    execute 'colorscheme ' . theme.name
  catch /^Vim\%((\a\+)\)\=:E185/
    if !silent_mode
      echohl ErrorMsg
      echom "Theme not found: " . theme.name
      echohl None
    endif
    return
  endtry

  if !empty(globpath(&rtp, 'autoload/airline/themes/'.theme.airline.'.vim'))
    let g:airline_theme = theme.airline
  elseif !silent_mode
    echohl WarningMsg
    echom "Airline theme not found: " . theme.airline
    echohl None
  endif

  " Force PaperColor to dark mode, others use dark by default
  if theme.name ==# 'PaperColor'
    set background=dark
  else
    set background=dark
  endif
  call writefile([string(a:idx)], s:theme_file)
endfunction

function! CycleTheme(direction)
  let g:current_theme_index = (g:current_theme_index + a:direction + len(g:themes)) % len(g:themes)
  call SetTheme(g:current_theme_index, 0)
endfunction

nnoremap <leader><Right> :call CycleTheme(1)<CR>
nnoremap <leader><Left>  :call CycleTheme(-1)<CR>

" On startup, set theme silently
if has('vim_starting')
  call SetTheme(g:current_theme_index, 1)
else
  call SetTheme(g:current_theme_index, 0)
endif
