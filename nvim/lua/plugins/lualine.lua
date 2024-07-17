return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function ()
    local lualine = require("lualine")

    local theme = require'lualine.themes.tokyonight'

    local colors = {
      foreground = "#7dcfff"
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
      end,
    }

    lualine.setup({
      sections = {
        -- This will hide branch, it's not needed since we have the current branch in tmux
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            cond = conditions.buffer_not_empty,
            color = { fg = colors.foreground, gui = 'bold' },
            path = 4
          }
        },
      },
      options = {
        theme = theme
      }
    })
  end
}
