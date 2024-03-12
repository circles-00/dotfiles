local M = {}


M.filetype = function()
  return vim.api.nvim_buf_get_option(vim.fn.winbufnr(vim.g.statusline_winid), 'filetype')

end

M.git_branch = function()
  local handle = io.popen("git branch --show-current 2>nul")

  if not handle then
    return ""
  end

  local result = handle:read("*a")
  handle:close()
  return result:match("%S+")
end

function statusline()
  return table.concat(
    { "%#StatusLine#"
    , " %-t %-m %-r"
    , "%="
    , " " .. M.git_branch() .. " "
    , "%2(%c%), %2(%l%):%L "
    , M.filetype()
    })
end

M.setup = function()
  -- Highlights
  vim.cmd [[highlight StatusLang gui=bold guifg=Black guibg=Blue]]
  vim.cmd [[highlight StatusModified gui=bold guifg=Black guibg=Red]]

  vim.o.statusline = "%!v:lua.statusline()"

  -- Autocommands necessary to guarantee the proper filetype is shown
  -- Without this, the statusline shows the active buffer's filetype on all windows
  vim.cmd [[augroup StatusLine
  autocmd!
  autocmd WinEnter,BufEnter * set statusline<
  autocmd WinLeave,BufLeave * lua vim.wo.statusline=statusline()
augroup END]]
end

return M
