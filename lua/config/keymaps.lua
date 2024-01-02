-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.api.nvim_set_keymap
local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

-- Better escape using jk in insert and terminal mode
keymap("i", "kj", "<Esc>", default_opts)
keymap("t", "kj", "<C-\\><C-n>", default_opts)

keymap("n", "msg", ":messages <CR>", default_opts)
keymap("n", "msgg", ":messages clear<CR>", default_opts)

-- center result
keymap("n", "msg", ":messages <CR>", default_opts)
keymap("n", "msgg", ":messages clear<CR>", default_opts)

-- Toggle fold or select option from popup menu
---@return string
map("n", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<CR>" or "za"
end, { expr = true, desc = "Toggle Fold" })

-- Focus the current fold by closing all others
map("n", "<S-Return>", "zMzv", { remap = true, desc = "Focus Fold" })

keymap(
  "n",
  "<leader>qr",
  "<cmd>lua require('fr.telescope').reload()<CR>",
  { desc = "Reload Neovim Lua Modules", noremap = true, silent = true }
)

keymap(
  "n",
  "<leader>fd",
  "<cmd>lua require('telescope.builtin').find_files({cwd=vim.fn.expand('%:p:h'), prompt_title=' Files in Current Buffer Dir '})<CR>",
  { desc = "Files in current buf Dir", noremap = true, silent = true }
)

keymap(
  "n",
  "<leader>fs",
  "<cmd>lua require('telescope').extensions.luasnip.luasnip{}<CR>",
  { desc = "Snippets for current ft", noremap = true, silent = true }
)

keymap("n", "<leader>wf", "<cmd>FocusToggle<CR>", { desc = "Toggle Focus", noremap = true, silent = false })
keymap(
  "n",
  "<leader>zz",
  "<cmd>lua require('zen-mode').toggle({ window = { width = .85 } })<CR>",
  { desc = "Zen Mode", noremap = true, silent = false }
)

-- Split window right
keymap("n", "<leader>\\", "<C-W>v", { desc = "Split window right", noremap = true })
