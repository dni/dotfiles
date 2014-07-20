execute pathogen#infect()

" save bind control-z
nmap <C-z> :w<CR>
imap <C-z> <esc>:w<CR>a

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

