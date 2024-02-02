local fn = vim.fn

local cwd = function()
  local dir_name = "%#St_cwd#󰉖 " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "
  return (vim.o.columns > 85 and dir_name) or ""
end

local cwd_bis = function()
  local dir_icon = "󰉋 "
  local dir_name = fn.fnamemodify(fn.getcwd(), ":t") .. " "
  return (vim.o.columns > 85 and ("%#LualineCwd#" .. dir_icon .. dir_name)) or ""
end

local modes = {
  ["n"] = { "NORMAL", "St_NormalMode" },
  ["no"] = { "NORMAL (no)", "St_NormalMode" },
  ["nov"] = { "NORMAL (nov)", "St_NormalMode" },
  ["noV"] = { "NORMAL (noV)", "St_NormalMode" },
  ["noCTRL-V"] = { "NORMAL", "St_NormalMode" },
  ["niI"] = { "NORMAL i", "St_NormalMode" },
  ["niR"] = { "NORMAL r", "St_NormalMode" },
  ["niV"] = { "NORMAL v", "St_NormalMode" },
  ["nt"] = { "NTERMINAL", "St_NTerminalMode" },
  ["ntT"] = { "NTERMINAL (ntT)", "St_NTerminalMode" },

  ["v"] = { "VISUAL", "St_VisualMode" },
  ["vs"] = { "V-CHAR (Ctrl O)", "St_VisualMode" },
  ["V"] = { "V-LINE", "St_VisualMode" },
  ["Vs"] = { "V-LINE", "St_VisualMode" },
  [""] = { "V-BLOCK", "St_VisualMode" },

  ["i"] = { "INSERT", "St_InsertMode" },
  ["ic"] = { "INSERT (completion)", "St_InsertMode" },
  ["ix"] = { "INSERT completion", "St_InsertMode" },

  ["t"] = { "TERMINAL", "St_TerminalMode" },

  ["R"] = { "REPLACE", "St_ReplaceMode" },
  ["Rc"] = { "REPLACE (Rc)", "St_ReplaceMode" },
  ["Rx"] = { "REPLACEa (Rx)", "St_ReplaceMode" },
  ["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
  ["Rvc"] = { "V-REPLACE (Rvc)", "St_ReplaceMode" },
  ["Rvx"] = { "V-REPLACE (Rvx)", "St_ReplaceMode" },

  ["s"] = { "SELECT", "St_SelectMode" },
  ["S"] = { "S-LINE", "St_SelectMode" },
  [""] = { "S-BLOCK", "St_SelectMode" },
  ["c"] = { "COMMAND", "St_CommandMode" },
  ["cv"] = { "COMMAND", "St_CommandMode" },
  ["ce"] = { "COMMAND", "St_CommandMode" },
  ["r"] = { "PROMPT", "St_ConfirmMode" },
  ["rm"] = { "MORE", "St_ConfirmMode" },
  ["r?"] = { "CONFIRM", "St_ConfirmMode" },
  ["x"] = { "CONFIRM", "St_ConfirmMode" },
  ["!"] = { "SHELL", "St_TerminalMode" },
}

local mode = function()
  -- if not is_activewin() then
  --   return ""
  -- end

  local m = vim.api.nvim_get_mode().mode
  return "%#" .. modes[m][2] .. "#" .. " " .. modes[m][1] .. ""
end

local custom_nord = require("lualine.themes.nord")
local colors = {
  nord1 = "#2E3440",
  statusline_bg = "#333945",
  statusline_fg = "#8a909c",
  nord2 = "#3B4252",
  nord3 = "#4C566A",
  nord5 = "#E5E9F0",
  nord6 = "#ECEFF4",
  nord7 = "#8FBCBB",
  nord8 = "#88C0D0",
  nord13 = "#EBCB8B",
}

custom_nord.normal.a.fg = colors.nord8
custom_nord.normal.a.bg = colors.nord2
custom_nord.normal.b.fg = colors.statusline_fg
custom_nord.normal.b.bg = colors.statusline_bg
custom_nord.normal.c.fg = colors.statusline_fg
custom_nord.normal.c.bg = colors.statusline_bg

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "meuter/lualine-so-fancy.nvim",
    },
    opts = function(_, opts)
      table.insert(opts.sections.lualine_z, 1, { cwd() })
      opts.sections.lualine_a = {
        { "mode", icons_enabled = true, icon = "" },
      }
      opts.options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        theme = custom_nord,
      }
    end,
  },
}
