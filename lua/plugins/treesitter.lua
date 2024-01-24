return {
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      { "nvim-treesitter/nvim-treesitter-context", opts = { enable = false } },
      "JoosepAlviste/nvim-ts-context-commentstring",
      "RRethy/nvim-treesitter-endwise",
      "windwp/nvim-ts-autotag",
      "andymass/vim-matchup",
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = true },
      },
      -- See: https://github.com/RRethy/nvim-treesitter-endwise
      endwise = { enable = true },
      -- See: https://github.com/andymass/vim-matchup
      matchup = {
        enable = true,
        include_match_words = true,
      },
      -- See: https://github.com/windwp/nvim-ts-autotag
      autotag = {
        enable = true,
        -- Removed markdown due to errors
        filetypes = {
          "glimmer",
          "handlebars",
          "hbs",
          "html",
          "javascript",
          "javascriptreact",
          "jsx",
          "rescript",
          "svelte",
          "tsx",
          "typescript",
          "typescriptreact",
          "vue",
          "xml",
        },
      },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  -- nvim-treesitter-endwise
  { "RRethy/nvim-treesitter-endwise" },
  -- andymass/vim-matchup
  {
    "andymass/vim-matchup",
    init = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  -- hlargs.nvim
  {
    "m-demare/hlargs.nvim",
    event = "VeryLazy",
    opts = {
      color = "#ef9062",
      use_colorpalette = false,
      disable = function(_, bufnr)
        if vim.b.semantic_tokens then
          return true
        end
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        for _, c in pairs(clients) do
          local caps = c.server_capabilities
          if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            vim.b.semantic_tokens = true
            return vim.b.semantic_tokens
          end
        end
      end,
    },
  },

  -- tree-sitter-blade
  {
    "EmranMR/tree-sitter-blade",
    opts = {},
    config = function()
      return {
        ensure_installed = "blade",
        highlight = {
          enable = true,
        },
      }
    end,
  },
}
