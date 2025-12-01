return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    vim.opt.termguicolors = true
    local mocha = require('catppuccin.palettes').get_palette 'mocha'
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        numbers = 'none',
        themable = true,
        diagnostics = 'nvim_lsp',
        separator_style = 'thin', -- "slant" | "slope" | "thick" | "thin"
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            highlight = 'Directory',
            separator = true,
          },
        },
      },
      highlights = require('catppuccin.special.bufferline').get_theme {
        custom = {
          mocha = {
            -- buffer_selected = { bg = '#1e1e2e' },
            buffer_selected = {
              fg = mocha.text,
              bg = mocha.base,
              bold = true,
            },
            warning_selected = { bg = mocha.base },
            warning_diagnostic_selected = { bg = mocha.base },

            error_selected = { bg = mocha.base },
            error_diagnostic_selected = { bg = mocha.base },

            info_selected = { bg = mocha.base },
            info_diagnostic_selected = { bg = mocha.base },

            hint_selected = { bg = mocha.base },
            hint_diagnostic_selected = { bg = mocha.base },

            duplicate_selected = { bg = mocha.base },
          },
        },
      },
    }
    vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>')
    vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>')

    vim.keymap.set('n', '<leader>bn', '<Cmd>BufferLineMoveNext<CR>')
    vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLineMovePrev<CR>')

    vim.keymap.set('n', '<leader>bb', '<Cmd>BufferLinePick<CR>')

    vim.keymap.set('n', '<leader>bd', '<Cmd>bdelete<CR>')
  end,
}
