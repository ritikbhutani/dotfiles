vim.cmd("set expandtab")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set tabstop=4 softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")
vim.cmd("set smartindent")
vim.cmd("set clipboard=unnamed")

vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
vim.keymap.set('n', '<c-f>', ':silent !tmux neww tmux-sessionizer<CR>')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('v', '<leader>p', '"_dPV')
vim.keymap.set('n', '<leader>pv', ':Vex<CR>')
vim.keymap.set('n', '<leader><CR>', ':so ~/.config/nvim/init.lua<CR>')
vim.keymap.set('n', '<leader>pg', ':GFiles<CR>')
vim.keymap.set('n', '<leader>pf', ':Files<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

vim.keymap.set('i', 'jk', '<esc>')

vim.opt.clipboard = "unnamedplus"
