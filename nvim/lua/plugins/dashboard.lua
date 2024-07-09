local header = [[
  ███████╗███████╗ ██████╗  ██████╗██╗███████╗████████╗██╗   ██╗
  ██╔════╝██╔════╝██╔═══██╗██╔════╝██║██╔════╝╚══██╔══╝╚██╗ ██╔╝
  █████╗  ███████╗██║   ██║██║     ██║█████╗     ██║    ╚████╔╝
██╔══╝  ╚════██║██║   ██║██║     ██║██╔══╝     ██║     ╚██╔╝
██║     ███████║╚██████╔╝╚██████╗██║███████╗   ██║      ██║
╚═╝     ╚══════╝ ╚═════╝  ╚═════╝╚═╝╚══════╝   ╚═╝      ╚═╝

    ╔═════════╗
    ║ circles ║
    ╚═════════╝
]]

header = string.rep("\n", 8) .. header .. "\n\n"

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup({
      theme = 'doom',
      config = {
        header = vim.split(header, "\n"),
        center = {
          {
            icon = '',
            icon_hl = 'group',
            desc = 'uber',
            desc_hl = 'group',
            key = 'l33t',
            key_hl = 'group',
            key_format = '%s', -- `%s` will be substituted with value of `key`
            action = '',
          },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      }
    })
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
