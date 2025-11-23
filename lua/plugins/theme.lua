return {
  'lmantw/themify.nvim',

  lazy = false,
  priority = 999,

  config = function()
    require('themify').setup {

      'folke/tokyonight.nvim',
      'yorumicolors/yorumi.nvim',
      'catppuccin/nvim',

      'default',
    }
  end,
}
