return {
  'Saghen/blink.cmp',
  event = 'InsertEnter',
  version = '1.*',

  dependencies = {
    'neovim/nvim-lspconfig',
    'zbirenbaum/copilot.lua',
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
    },
    'folke/lazydev.nvim', -- optional Lua dev source
    'fang2hou/blink-copilot',
  },

  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
    },
    menu = {
      draw = {
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind_icon', 'kind' },
        },
      },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      menu = { border = 'rounded' },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
        window = { border = 'rounded' },
      },
      ghost_text = { enabled = true },
    },

    snippets = { preset = 'luasnip' },

    sources = {
      default = {
        'lsp', -- Language server completions
        'path', -- File paths
        'buffer', -- Buffer words
        'snippets', -- LuaSnip
        'lazydev', -- For Lua
      },
      providers = {
        lazydev = {
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        copilot = {
          name = 'copilot',
          module = 'blink-copilot',
          async = true,
        },
      },
    },

    signature = { enabled = true },
  },
}
