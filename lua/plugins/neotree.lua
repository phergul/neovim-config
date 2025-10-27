return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = 'open_default',
      },
      window = {
        width = 30,
        mappings = {
          ['<space>'] = 'none', -- disable space toggling folders if you prefer
          ['l'] = 'open', -- open file or expand folder
          ['h'] = 'close_node', -- collapse folder
        },
      },
    }

    vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree file explorer' })

    vim.keymap.set('n', '<leader>st', '<cmd>Neotree focus<CR>', { desc = 'Focus Neo-tree file explorer' })

    vim.keymap.set('n', '<leader>sv', '<cmd>Neotree reveal<CR>', { desc = 'Reveal current file in Neo-tree' })
  end,
}
