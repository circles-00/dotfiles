--return {
--  'rose-pine/neovim',
--  name = 'rose-pine',
--  config = function()
--    vim.cmd('colorscheme rose-pine')
--
--    vim.api.nvim_set_hl(0, "Normal", { bg ="none"})
--    vim.api.nvim_set_hl(0, "NormalFloat", { bg ="none"})
--  end
--}

--return {
--  "catppuccin/nvim",
--  name = "catppuccin",
--  priority = 1000,
--  lazy = false,
--  config = function()
--    vim.cmd('colorscheme catppuccin-mocha')
--  end,
--
--}
--

return {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd('colorscheme tokyonight-night')
    end,
  }

--return {
--    "tiagovla/tokyodark.nvim",
--    opts = {
--        -- custom options here
--    },
--    config = function(_, opts)
--        require("tokyodark").setup(opts) -- calling setup is optional
--        vim.cmd [[colorscheme tokyodark]]
--    end,
--}

