-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.foldcolumn = "1" -- '0' is not bad
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.foldmethod = "indent"

opt.laststatus = 3 -- global statusline
opt.colorcolumn = ""

vim.g.nord_contrast = false
vim.g.nord_borders = false
vim.g.disable_background = false
vim.g.nord_italic = false
vim.g.nord_cursorline_transparent = false
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = true
