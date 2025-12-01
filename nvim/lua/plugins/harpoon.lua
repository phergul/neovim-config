return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    local list = harpoon:list()
    local ui = harpoon.ui

    vim.keymap.set('n', '<leader>a', function()
      list:add()
    end)
    vim.keymap.set('n', '<C-e>', function()
      ui:toggle_quick_menu(list)
    end)

    vim.keymap.set('n', '<C-h>', function()
      list:select(1)
    end)
    vim.keymap.set('n', '<C-j>', function()
      list:select(2)
    end)
    vim.keymap.set('n', '<C-k>', function()
      list:select(3)
    end)
    vim.keymap.set('n', '<C-l>', function()
      list:select(4)
    end)
  end,
}
