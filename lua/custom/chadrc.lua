---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")
M.ui = {
  hl_add = highlights.add,
  hl_override = highlights.override,
  theme_toggle = { "nord", "one_light" },
  theme = "nord",
  transparency = false,
  lsp_semantic_tokens = true,

  extended_integrations = { "notify", "trouble", "bufferline" },

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default",
    border_color = "grey_fg",
    selected_item_bg = "colored",
  },

  telescope = { style = "borderless" },

  statusline = {
    theme = "vscode_colored",
    enabled = false,
    separator_style = "default",
    overriden_modules = function(modules)
      -- table.insert(modules, 10, progress())
    end,
  },

  cheatsheet = { theme = "grid" }, -- simple/grid
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
