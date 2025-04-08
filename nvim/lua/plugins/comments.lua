return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,

    keywords = {
      TODO = { icon = " ", color = "warning" },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    }
  }
}
