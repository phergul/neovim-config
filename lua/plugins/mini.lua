return {
  { 'nvim-mini/mini.nvim', version = false },
  {
    'nvim-mini/mini.files',
    config = function()
      local minifiles = require 'mini.files'
      minifiles.setup {}
      vim.keymap.set('n', '<leader>ee', '<cmd>lua MiniFiles.open()<CR>', { desc = 'Open File Explorer' })
      vim.keymap.set('n', '<leader>ef', function()
        minifiles.open(vim.api.nvim_buf_get_name(0), false)
        minifiles.reveal_cwd()
      end, { desc = 'Open File Explorer at current file' })
    end,
  },
  -- 'echasnovski/mini.nvim',
  -- config = function()
  --   -- Examples:
  --   --  - va)  - [V]isually select [A]round [)]paren
  --   --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
  --   --  - ci'  - [C]hange [I]nside [']quote
  --   require('mini.ai').setup { n_lines = 500 }
  --
  --   -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  --   -- - sd'   - [S]urround [D]elete [']quotes
  --   -- - sr)'  - [S]urround [R]eplace [)] [']
  --   require('mini.surround').setup()
  --
  --   local statusline = require 'mini.statusline'
  --   statusline.setup { use_icons = vim.g.have_nerd_font }
  --
  --   ---@diagnostic disable-next-line: duplicate-set-field
  --   statusline.section_location = function()
  --     return '%2l:%-2v'
  --   end
  -- end,
}
