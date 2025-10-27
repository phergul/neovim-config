return {
  'yorumicolors/yorumi.nvim',
  name = 'yorumi',
  priority = 1000, -- load before other plugins
  config = function()
    vim.cmd.colorscheme 'yorumi'
  end,
}
