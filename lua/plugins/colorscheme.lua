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
    opts = {
      style = "storm",
      on_highlights = function(highlights, colors)
        -- Colors for Snacks pickers
        highlights.SnacksPickerBoxTitle = { bg = "#1c99f2", fg = "#ffffff", bold = true }
        highlights.SnacksPickerInput = { bg = "#23273b", fg = "#C0CAF5" }
        highlights.SnacksPickerInputBorder = { bg = "#23273b", fg = "#23273b" }
        highlights.SnacksPickerInputTitle = { bg = "#1c99f2", fg = "#ffffff", bold = true }
        highlights.SnacksPickerList = { bg = "#262e46" }
        highlights.SnacksPickerListBorder = { bg = "#262e46", fg = "#23273b" }
        highlights.SnacksPickerListCursorLine = { bg = "#1a1d2f" }
        highlights.SnacksPickerPreviewBorder = { bg = "#16161E", fg = "#23273b" }
        highlights.SnacksPickerPrompt = { bg = "#23273b", fg = "#1c99f2" }
      end,
    },
  },
}
