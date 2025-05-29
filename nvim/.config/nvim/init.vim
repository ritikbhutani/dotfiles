set scrolloff=8
set number
set relativenumber
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

let mapleader = " "
nnoremap <leader>pv :Vex<CR>
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>pg :GFiles<CR>
nnoremap <leader>pf :Files<CR>
nnoremap <leader>j :cnext<CR>
nnoremap <leader>k :cprev<CR>
inoremap jk <esc>
vnoremap <leader>p "_dPV
vnoremap <leader>y "+y
nnoremap <leader>y "+y

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

call plug#end()

colorscheme catppuccin-mocha
