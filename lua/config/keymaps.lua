vim.keymap.set('n', '<leader>w', '<cmd>w<cr><esc>', { desc = 'Write file' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<A-h>', '<C-w>h', opts)
vim.keymap.set('n', '<A-j>', '<C-w>j', opts)
vim.keymap.set('n', '<A-k>', '<C-w>k', opts)
vim.keymap.set('n', '<A-l>', '<C-w>l', opts)

vim.keymap.set('i', '<A-h>', '<Esc><C-w>h', opts)
vim.keymap.set('i', '<A-j>', '<Esc><C-w>j', opts)
vim.keymap.set('i', '<A-k>', '<Esc><C-w>k', opts)
vim.keymap.set('i', '<A-l>', '<Esc><C-w>l', opts)

vim.keymap.set('t', '<A-h>', [[<C-\><C-n><C-w>h]], opts)
vim.keymap.set('t', '<A-j>', [[<C-\><C-n><C-w>j]], opts)
vim.keymap.set('t', '<A-k>', [[<C-\><C-n><C-w>k]], opts)
vim.keymap.set('t', '<A-l>', [[<C-\><C-n><C-w>l]], opts)
