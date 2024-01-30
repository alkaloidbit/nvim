local fn = vim.fn
local cwd = function()
  local dir_icon = "󰉋 "
  local dir_name = fn.fnamemodify(fn.getcwd(), ":t") .. " "
  return (vim.o.columns > 85 and ("%#LualineCwd#" .. dir_icon .. dir_name)) or ""
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
      table.insert(opts.sections.lualine_x, { "fancy_cwd", { substitute_home = true, colored = false } })
      -- table.insert(opts.sections.lualine_a, { "mode", icons_enabled = true, icon = "" })
      -- This is the only way to change current lualine section
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
