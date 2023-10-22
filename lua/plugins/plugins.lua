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

  {
    "folke/tokyonight.nvim",
    opts = { style = "storm" },
  },

  -- noice.nvim
  { "folke/noice.nvim", opts = { lsp = { progress = { enabled = false } } } },

  -- fidget
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {
      -- options
    },
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
  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- phpactor will be automatically installed with mason and loaded with lspconfig
        phpactor = {},
        intelephense = {},
        pyright = {},
      },
    },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- Use <tab> for completion and snippets (supertab)
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },

  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },

  -- Diffview
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<Leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Diff View" },
    },
    opts = function()
      local actions = require("diffview.actions")
      vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("rafi_diffview", {}),
        pattern = "diffview:///panels/*",
        callback = function()
          vim.opt_local.winhighlight = "CursorLine:WildMenu"
        end,
      })

      return {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        keymaps = {
          view = {
            { "n", "q", "<cmd>DiffviewClose<CR>" },
            { "n", "<Tab>", actions.select_next_entry },
            { "n", "<S-Tab>", actions.select_prev_entry },
            { "n", "<LocalLeader>a", actions.focus_files },
            { "n", "<LocalLeader>e", actions.toggle_files },
          },
          file_panel = {
            { "n", "q", "<cmd>DiffviewClose<CR>" },
            { "n", "h", actions.prev_entry },
            { "n", "o", actions.focus_entry },
            { "n", "gf", actions.goto_file },
            { "n", "sg", actions.goto_file_split },
            { "n", "st", actions.goto_file_tab },
            { "n", "<C-r>", actions.refresh_files },
            { "n", ";e", actions.toggle_files },
          },
          file_history_panel = {
            { "n", "q", "<cmd>DiffviewClose<CR>" },
            { "n", "o", actions.focus_entry },
            { "n", "O", actions.options },
          },
        },
      }
    end,
  },

  -- Neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<Leader>gn", "<cmd>Neogit<CR>", desc = "Neogit" },
    },
    -- See: https://github.com/TimUntersberger/neogit#configuration
    opts = {
      disable_signs = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      signs = {
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
    },
  },
  -- nvim-bqf
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    cmd = "BqfAutoToggle",
    event = "QuickFixCmdPost",
    opts = {
      auto_resize_height = false,
      func_map = {
        tab = "st",
        split = "sv",
        vsplit = "sg",

        stoggleup = "K",
        stoggledown = "J",
        stogglevm = "<Space>",

        ptoggleitem = "p",
        ptoggleauto = "P",
        ptogglemode = "zp",

        pscrollup = "<C-b>",
        pscrolldown = "<C-f>",

        prevfile = "gk",
        nextfile = "gj",

        prevhist = "<S-Tab>",
        nexthist = "<Tab>",
      },
      preview = {
        auto_preview = true,
        should_preview_cb = function(bufnr)
          -- file size greater than 100kb can't be previewed automatically
          local filename = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(filename)
          if fsize > 100 * 1024 then
            return false
          end
          return true
        end,
      },
    },
  },
  { "nelsyeung/twig.vim" },
}
