local make_bg_transparent = function()
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
end


local rosepine = {
  'rose-pine/neovim',
  name = 'rose-pine',
  config = function()
    vim.cmd('colorscheme rose-pine')

    make_bg_transparent()
  end
}

local catppuccin =  {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    vim.cmd('colorscheme catppuccin-mocha')

    make_bg_transparent()
  end,

}


local tokyonight = {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("tokyonight").setup({
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })

      vim.cmd.colorscheme("tokyonight")

      make_bg_transparent()
    end,
  }

local tokyodark = {
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd.colorscheme("tokyodark")

        make_bg_transparent()
    end,
}


local colors = {
  rosepine = rosepine,
  catppuccin = catppuccin,
  tokyonight = tokyonight,
  tokyodark  = tokyodark,
}

return colors["tokyonight"]
