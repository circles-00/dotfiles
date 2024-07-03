return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function ()
    local lualine = require("lualine")

    local theme = require'lualine.themes.tokyonight'

    lualine.setup({
      options = {
        theme = theme
      }
    })
  end
}
