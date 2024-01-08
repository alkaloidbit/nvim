local fn = vim.fn
local cwd = function()
  local dir_icon = "󰉋 "
  local dir_name = fn.fnamemodify(fn.getcwd(), ":t") .. " "
  return (vim.o.columns > 85 and ("%#LualineCwd#" .. dir_icon .. dir_name)) or ""
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "meuter/lualine-so-fancy.nvim",
    },
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, { "fancy_cwd", substitute_home = true })
      opts.options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      }
    end,
  },
}
