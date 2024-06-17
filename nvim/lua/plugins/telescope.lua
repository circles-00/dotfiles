return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  -- or                            , branch = '0.1.x',
  dependencies = { { 'nvim-lua/plenary.nvim' }, {"smartpde/telescope-recent-files"} },
  config = function ()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')

    telescope.setup({
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
        },
        git_files = {
          theme = "dropdown",
          previewer = false,
        },
      },
      extensions = {
        recent_files = {
          only_cwd = true
        }
      }
    })

    telescope.load_extension("recent_files")
    vim.api.nvim_set_keymap("n", "<Leader><Leader>",
    [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
    {noremap = true, silent = true})

    vim.keymap.set('n', '<leader>pf', builtin.git_files, {})
    vim.keymap.set('n', '<C-p>', builtin.find_files, {})
    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)
    vim.keymap.set('n', "<leader>pa", builtin.live_grep, {})
    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

  end
}

