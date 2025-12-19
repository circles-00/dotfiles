vim.g.mapleader = " "

-- Unbind arrow keys, until I learn hjkl
vim.keymap.set("n", "<Up>", "<nop>")
vim.keymap.set("n", "<Down>", "<nop>")
vim.keymap.set("n", "<Left>", "<nop>")
vim.keymap.set("n", "<Right>", "<nop>")

-- Unbind arrow keys, until I learn hjkl
vim.keymap.set("i", "<Up>", "<nop>")
vim.keymap.set("i", "<Down>", "<nop>")
vim.keymap.set("i", "<Left>", "<nop>")
vim.keymap.set("i", "<Right>", "<nop>")

-- Unbind ESC key, until I learn C-c
vim.keymap.set("i", "<Esc>", "<nop>")

-- Reload all buffers at once
vim.keymap.set("n", "<leader>ra", function()
  vim.cmd("bufdo e")
  print("Reloaded all buffers")
end)
vim.keymap.set("n", "<leader>rf", function()
  vim.cmd("bufdo e!")
  print("! Reloaded all buffers")
end)

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Write, Quit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>po", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])


vim.keymap.set({ "n", "v" }, "<leader>P", [["+p]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format()
  local currentFileName = vim.fn.expand("%:t")

  if currentFileName:sub(-3) == ".ts" or currentFileName:sub(-4) == ".tsx" then
  vim.cmd("EslintFixAll")
end
end
)

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- Custom typescript barrel generator script & remap
vim.keymap.set("n", "<leader>ts", function ()
  local currentDirectoryPath = vim.fn.expand("%:p:h")
  vim.cmd("!node ~/.local/scripts/typescript-barrel-generator.js " .. currentDirectoryPath)
end)

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bdd", "<cmd>:bd<cr>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bda", "<cmd>:%bd|e#|bd#<cr>", { desc = "Delete All Buffers But This One" })

-- Claude code
vim.api.nvim_set_keymap(
  "n",
  "<leader>cc",
  ":lua os.execute(\"tmux split-window -h -p 30 'zsh -c \\\"source ~/.zshrc && claude\\\"'\")<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>cg",
  ":lua os.execute(\"tmux split-window -h -p 30 'zsh -c \\\"source ~/.zshrc && gemini\\\"'\")<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>cs",
  ":lua os.execute(\"tmux split-window -h -p 30 'zsh -c \\\"source ~/.zshrc && cursor-agent\\\"'\")<CR>",
  { noremap = true, silent = true }
)
