return {
    { "lewis6991/gitsigns.nvim",
    config = function()
      local gitsigns = require('gitsigns')
      gitsigns.setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 200
        }
      })

      vim.keymap.set('n', "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
    end
  },
  {
    'akinsho/git-conflict.nvim',
    version = "*",
    config = true
  }
}
