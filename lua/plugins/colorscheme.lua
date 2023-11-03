---@diagnostic disable: missing-fields
return {
  -- add Nord theme
  {
    url = "git@github.com:alkaloidbit/nord.nvim",
    branch = "localchanges",
  },

  -- Configure LazyVim to load nord
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin",
      colorscheme = "nord",
      -- colorscheme = "tokyonight",
    },
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    opts = { style = "storm" },
  },
}
