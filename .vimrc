execute pathogen#infect()
let mapleader = ","
" save bind control-z
nmap <C-x> :q<CR>
nmap <C-x><C-x> :q!<CR>
nmap <C-z> :w<CR>
nmap <leader>h :nohl<CR>
nmap <leader>c gcc
nmap <C-h> :set hlsearch!<CR>
nmap <leader>l <C-w><C-w> 

filetype plugin indent on
set noswapfile
set number
set hlsearch

" airline
set laststatus=2

" tab / space settings
set expandtab
set tabstop=2
retab
set shiftwidth=2

" colors
let g:solarized_termcolors=256
syntax enable
set background=dark
colorscheme solarized

" nerdtree
let g:nerdtree_plugin_open_cmd = 'open'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

