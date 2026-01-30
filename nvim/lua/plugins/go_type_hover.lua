return {
  'go-type-hover.nvim',
  dev = true,
  opts = {
    float = {
      show_footer = false,
    },
  },
  config = function(_, opts)
    require('go_type_hover').setup(opts)
  end,
}
