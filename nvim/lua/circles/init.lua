require("circles.set")
require("circles.remap")
local statusLine = require("circles.status_line")

-- DO NOT INCLUDE THIS
-- vim.opt.rtp:append("~/personal/streamer-tools")
-- DO NOT INCLUDE THIS

local augroup = vim.api.nvim_create_augroup
local CirclesGroup = augroup('circles', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
  require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

autocmd({ "BufWritePre" }, {
  group = CirclesGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

statusLine.setup()

