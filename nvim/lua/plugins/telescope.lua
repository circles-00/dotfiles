return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  -- or                            , branch = '0.1.x',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      "isak102/telescope-git-file-history.nvim",
      dependencies = { "tpope/vim-fugitive" }
    }
  },
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
    })

    telescope.load_extension("git_file_history")
    vim.keymap.set('n', '<leader>gh', telescope.extensions.git_file_history.git_file_history, {})

    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})

    vim.keymap.set('n', '<leader>pa', function()
      builtin.grep_string({
        search = vim.fn.input("Grep > "),
        additional_args = function(args)
          return vim.list_extend(args, { "--hidden" })
        end,
      })
    end)

    vim.keymap.set('n', '<leader>ps', function()
      builtin.live_grep({
        additional_args = function(args)
          return vim.list_extend(args, { "--hidden", "--fixed-strings" })
        end,
      })
    end)

    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

    vim.keymap.set('n', '<S-p>', "<cmd>Telescope commands<CR>")
  end
}

