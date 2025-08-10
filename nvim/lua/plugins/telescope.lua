return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  -- or                            , branch = '0.1.x',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {  "nvim-telescope/telescope-ui-select.nvim" },
    {
      "isak102/telescope-git-file-history.nvim",
    }
  },
  config = function ()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')

    telescope.setup({
      defaults = {
        layout_strategy = "flex",
        prompt_prefix = "   ",
        layout_config = {
          horizontal = {
            prompt_position = "bottom",
            height = 0.8,
            width = 0.70,
            preview_width = 0.45
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            border = true,
            borderchars = {
              "─", "│", "─", "│", "┌", "┐", "┘", "└"
            },
          }
        }
      },
      pickers = {
        find_files = {
          previewer = false,
          path_display = function(_, path)
            local tail = require("telescope.utils").path_tail(path)
            local dir = vim.fn.fnamemodify(path, ":h")
            if dir == "." then
              dir = ""
            else
              dir = "  " .. dir
            end
            local display = tail .. "   ~" .. dir
            return display, {
              { { 1, #tail }, "TelescopeResultsIdentifier" },
              { { #tail + 1, #display }, "NonText" }
            }
          end,
        },
        git_files = {
          previewer = false,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
        },
        diagnostics = {
          theme = "dropdown",
          previewer = false,
          path_display = { 'tail' }
        },
      },
    })

    telescope.load_extension("ui-select")
    telescope.load_extension("git_file_history")

    vim.keymap.set('n', '<leader>gh', telescope.extensions.git_file_history.git_file_history, {})

    vim.keymap.set('n', '<leader>pf', builtin.git_files, {})
    vim.keymap.set('n', '<C-p>', function()
      builtin.find_files({
        hidden = true
      })
    end, {})

    vim.keymap.set('n', '<leader>pa', function()
      builtin.grep_string({
        search = vim.fn.input("Grep > "),
        additional_args = function(args)
          return vim.list_extend(args, { "--hidden" })
        end,
      })
    end)

    vim.keymap.set('n', '<leader>ps', function()
      require('telescope.builtin').live_grep({
        additional_args = function()
          return { "--hidden", "--fixed-strings" }
        end,
      })
    end)


    vim.keymap.set('n', '<leader>pg', function()
      builtin.live_grep({
        additional_args = function()
          return { "--hidden", "--fixed-strings", "--ignore-case" }
        end,
      })
    end)

    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

    vim.keymap.set('n', '<S-p>', "<cmd>Telescope commands<CR>")
    vim.keymap.set("n", "<leader>j", builtin.diagnostics)
    vim.keymap.set("n", "<leader>pb", builtin.buffers)
  end
}

