return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,

    keywords = {
      TODO = { icon = " ", color = "warning" },
    }
  }
}
