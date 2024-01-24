require("core")

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Set lsp log level
-- vim.lsp.set_log_level("debug")
