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

-- Toggle fold or select option from popup menu
---@return string
map("n", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<CR>" or "za"
end, { expr = true, desc = "Toggle Fold" })

-- Focus the current fold by closing all others
map("n", "<S-Return>", "zMzv", { remap = true, desc = "Focus Fold" })

-- Replace word under cursor in Buffer (case-sensitive)
-- nmap <leader>srb :%s/<C-R><C-W>//gI<left><left><left>
keymap(
  "n",
  "<leader>srb",
  ":%s/<C-R><C-W>//gI<left><left><left>",
  { desc = "Replace word under cursor in Buffer (case-sensitive)", noremap = false }
)

-- Replace word under cursor on Line (case-sensitive)
-- nmap <leader>srl :s/<C-R><C-W>//gI<left><left><left>
keymap(
  "n",
  "<leader>srl",
  ":s/<C-R><C-W>//gI<left><left><left>",
  { desc = "Replace word under cursor on Line (case-sensitive)", noremap = false }
)

-- Split window right
keymap("n", "<leader>\\", "<C-W>v", { desc = "Split window right", noremap = true })
