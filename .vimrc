execute pathogen#infect()
filetype plugin indent on
syntax enable

let mapleader = "-"
nmap - <nop>

" good practice
" map <up> <nop>
" map <down> <nop>
" map <left> <nop>
" map <right> <nop>

" imap <up> <nop>
" imap <down> <nop>
" imap <left> <nop>
" imap <right> <nop>

" own config binds
nmap <C-x> :q<CR>
nmap <C-x><C-x> :q!<CR>
nmap <C-y> :w<CR>
nnoremap <C-z> <NOP>
nmap <leader>h :nohl<CR>
nmap <leader>c gcc
nmap <C-h> :set hlsearch!<CR>
nmap <c-space> <C-w><C-w>
nmap <leader>l <C-w><C-w>
nmap <c-l> <C-w><C-w>
nmap <c-h> <C-w>h
nmap <leader>f gg=G
nmap <c-k> :bnext<cr>
nmap <c-j> :bprevious<cr>
nmap <space> /


set noswapfile
set number
set hlsearch
set cursorline
" airline
" let g:airline_theme="badwolf"
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
set ttimeoutlen=50
set encoding=utf-8
set laststatus=2

" tab / space settings
set expandtab
set tabstop=2
retab
set shiftwidth=2

" remove trailing whitespace before saving
autocmd BufWritePre * :%s/\s\+$//e

" colors
let g:solarized_termcolors=256
set background=dark
colorscheme badwolf

" markown
let g:vim_markdown_folding_disabled=1

" nerdtree
let g:nerdtree_plugin_open_cmd = 'open'
map <C-n> :NERDTreeToggle<CR>
" let NERDTreeShowHidden=1
"
"
" CLIPBORAD ON MACOSX
set clipboard=unnamed


" SNIPPETS
ab print_r echo "<pre>";<CR>print_r();<CR>die();<ESC>kf)



