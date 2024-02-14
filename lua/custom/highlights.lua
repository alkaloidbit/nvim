-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
  },
  DiffAdd = { fg = "green", bg = "#3b4252" },
  DiffDelete = { fg = "red", bg = "#3b4252" },
  DiffChange = { fg = "yellow", bg = "#3b4252" },
  DiffText = { fg = "purple", bg = "#3b4252" },
  NeoTreeGitModified = { fg = "yellow", bg = "#2e3440" },
  NeoTreeGitAdded = { fg = "green", bg = "#2e3440" },
  St_cwd = { fg = "red", bg = "statusline_bg" },
  MatchWord = { bold = true, fg = "#b48ead" },

  IlluminatedWordText = { underline = false, bg = "#4c566a" },
  IlluminatedWordRead = { underline = false, bg = "#4c566a" },
  IlluminatedWordWrite = { underline = false, bg = "#4c566a" },

  DiagnosticHint = { fg = "#7797b7" },
  NeoTreeNormal = { bg = "#2a303c" },
  NeoTreeCursorLine = { fg = "purple", bg = "#2a303c" },
  Constant = { bold = true },
  BufferLineFill = { bg = "#2e3440" },
  NeoTreeVertSplit = { fg = "#2e3440", bg = "#2e3440" },
  NeoTreeWinSeparator = { fg = "#2e3440", bg = "#2e3440" },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },

  DashboardFooter = { italic = true, fg = "#e39a83" },
  DashboardHeader = { fg = "#7797b7" },
  DashboardCenter = { fg = "#9aafe6" },
  DashboardShortCut = { fg = "#e39a83" },

  IlluminatedWordText = { underline = false, bg = "#4c566a" },
  IlluminatedWordRead = { underline = false, bg = "#4c566a" },
  IlluminatedWordWrite = { underline = false, bg = "#4c566a" },
  NeoTreeNormal = { bg = "#2a303c" },
  NeoTreeOffset = { bg = "#2a303c", fg = "#e39a83" },
  NeoTreeGitModified = { fg = "yellow", bg = "#2e3440" },
  NeoTreeCursorLine = { fg = "blue", bg = "grey" },
  Constant = { bold = true },
  BufferLineFill = { bg = "#2e3440" },
  NeoTreeVertSplit = { fg = "#2e3440", bg = "#2e3440" },
  NeoTreeWinSeparator = { fg = "#2e3440", bg = "#2e3440" },
  AerialNormal = { fg = "nord_blue" },
}

return M
