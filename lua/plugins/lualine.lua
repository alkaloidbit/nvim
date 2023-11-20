local fn = vim.fn
local cwd = function()
  local dir_icon = "󰉋 "
  local dir_name = fn.fnamemodify(fn.getcwd(), ":t") .. " "
  -- return (vim.o.columns > 85 and ("%#lualine_x_diff_added_insert#" .. dir_icon .. dir_name)) or ""
  return (vim.o.columns > 85 and ("%#TabLineSel#" .. dir_icon .. dir_name)) or ""
  -- return (vim.o.columns > 85 and ("%#DiffChange#" .. dir_icon .. dir_name)) or ""
  -- return (vim.o.columns > 85 and ("%#Headline1#" .. dir_icon .. dir_name)) or ""
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, cwd)
    end,
  },
}
