return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup {
      check_ts = true,
      ts_config = {
        lua = { 'string' },
      },
      disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
      fast_wrap = {
        map = '<M-e>',
      },
    }
  end,
}
