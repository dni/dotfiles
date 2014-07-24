
execute pathogen#infect()
let mapleader = ","

" own config binds
nmap <C-x> :q<CR>
nmap <C-x><C-x> :q!<CR>
nmap <C-z> :w<CR>
nmap <leader>h :nohl<CR>
nmap <leader>c gcc
nmap <C-h> :set hlsearch!<CR>
nmap <leader>l <C-w><C-w>
nmap <leader>f gg=G
nmap <space> /

filetype plugin indent on
set noswapfile
set number
set hlsearch

" airline
" let g:airline_theme=dark
let g:airline_powerline_fonts = 1
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
syntax enable
set background=dark
colorscheme solarized

" nerdtree
let g:nerdtree_plugin_open_cmd = 'open'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
