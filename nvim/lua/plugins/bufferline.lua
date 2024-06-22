return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function ()
    vim.opt.termguicolors = true
    require("bufferline").setup({
      options = {
        themable = true,
        diagnostics = "nvim_lsp",
        color_icons = true
      }
    })
  end
}
