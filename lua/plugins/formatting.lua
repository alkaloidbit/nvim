return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["html.twig"] = { "prettier" },
        ["twig"] = { "prettier" },
        blade = { "blade-formatter" },
      },
    },
  },
}
