_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function()
  Snacks.debug.backtrace()
end
vim.print = _G.dd

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Set lsp log level
-- vim.lsp.set_log_level("debug")
