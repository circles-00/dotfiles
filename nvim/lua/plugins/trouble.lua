return {
  'folke/trouble.nvim',
  opts = {},
  cmd = "Trouble",
  enabled = false,
  keys = {
    {
      "<leader>j",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
  },
}

