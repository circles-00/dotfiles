return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    local lsp_lines = require("lsp_lines")

    lsp_lines.setup()

    lsp_lines.toggle()

    vim.keymap.set(
      "",
      "<Leader>e",
      lsp_lines.toggle,
      { desc = "Toggle lsp_lines" }
    )
  end,
}
