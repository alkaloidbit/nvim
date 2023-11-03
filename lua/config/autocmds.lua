-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_user_command("LspCapabilities", function()
  local curBuf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = curBuf })

  for _, client in pairs(clients) do
    if client.name ~= "null-ls" then
      local capAsList = {}
      for key, value in pairs(client.server_capabilities) do
        if value and key:find("Provider") then
          local capability = key:gsub("Provider$", "")
          table.insert(capAsList, "- " .. capability)
        end
      end
      table.sort(capAsList) -- sorts alphabetically
      local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
      vim.notify(msg, "info", {
        on_open = function(win)
          local buf = vim.api.nvim_win_get_buf(win)
          vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
        end,
        timeout = 14000,
      })
      vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
    end
  end
end, {})

-- requires plenary (which is required by telescope)
local Float = require("plenary.window.float")

vim.cmd([[
    augroup LspPhpactor
      autocmd!
      autocmd Filetype php command! -nargs=0 LspPhpactorReindex lua vim.lsp.buf_notify(0, "phpactor/indexer/reindex",{})
      autocmd Filetype php command! -nargs=0 LspPhpactorConfig lua LspPhpactorDumpConfig()
      autocmd Filetype php command! -nargs=0 LspPhpactorStatus lua LspPhpactorStatus()
      autocmd Filetype php command! -nargs=0 LspPhpactorBlackfireStart lua LspPhpactorBlackfireStart()
      autocmd Filetype php command! -nargs=0 LspPhpactorBlackfireFinish lua LspPhpactorBlackfireFinish()
    augroup END
]])

local function showWindow(title, syntax, contents)
  local out = {}
  for match in string.gmatch(contents, "[^\n]+") do
    table.insert(out, match)
  end

  local float = Float.percentage_range_window(0.6, 0.4, { winblend = 0 }, {
    title = title,
    topleft = "┌",
    topright = "┐",
    top = "─",
    left = "│",
    right = "│",
    botleft = "└",
    botright = "┘",
    bot = "─",
  })

  vim.api.nvim_buf_set_option(float.bufnr, "filetype", syntax)
  vim.api.nvim_buf_set_lines(float.bufnr, 0, -1, false, out)
end

function LspPhpactorDumpConfig()
  local results, _ = vim.lsp.buf_request_sync(0, "phpactor/debug/config", { ["return"] = true })
  for _, res in pairs(results or {}) do
    showWindow("Phpactor LSP Configuration", "json", res["result"])
  end
end
function LspPhpactorStatus()
  local results, _ = vim.lsp.buf_request_sync(0, "phpactor/status", { ["return"] = true })
  for _, res in pairs(results or {}) do
    showWindow("Phpactor Status", "markdown", res["result"])
  end
end

function LspPhpactorBlackfireStart()
  local _, _ = vim.lsp.buf_request_sync(0, "blackfire/start", {})
end
function LspPhpactorBlackfireFinish()
  local _, _ = vim.lsp.buf_request_sync(0, "blackfire/finish", {})
end
