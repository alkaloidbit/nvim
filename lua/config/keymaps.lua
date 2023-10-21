-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.api.nvim_set_keymap
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

keymap(
  "n",
  "<leader>qr",
  "<cmd>lua require('fr.telescope').reload()<CR>",
  { desc = "Reload Neovim Lua Modules", noremap = true, silent = true }
)

keymap(
  "n",
  ",d",
  "<cmd>lua require('telescope.builtin').find_files({cwd=vim.fn.expand('%:p:h'), prompt_title=' Files in Current Buffer Dir '})<CR>",
  { desc = "Files in current buf Dir", noremap = true, silent = true }
)
