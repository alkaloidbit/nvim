return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["php"] = { { "php_cs_fixer", "phpcbf" } },
        ["html.twig"] = { "prettier" },
        ["twig"] = { "prettier" },
      },
    },
  },
}
