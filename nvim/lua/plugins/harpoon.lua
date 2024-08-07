return {
  'theprimeagen/harpoon',
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function ()
    local harpoon = require("harpoon")

    harpoon:setup({
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    })

    -- setup telescope
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    vim.keymap.set("n", "<leader>a", function () harpoon:list():add() end)
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    vim.keymap.set("n", "<C-t>", function() toggle_telescope(harpoon:list()) end)

    vim.keymap.set("n", "<C-a>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-s>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-j>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-k>", function() harpoon:list():select(4) end)
    vim.keymap.set("n", "<C-l>", function() harpoon:list():select(5) end)

    -- Have Ctrl - 1 to Ctrl - 5 for files from 6 to 10
    for _, idx in ipairs { 1, 2, 3, 4, 5 } do
      vim.keymap.set("n", "<C-" .. idx .. ">", function()
        harpoon:list():select(idx + 5)
      end)
    end
  end
}

