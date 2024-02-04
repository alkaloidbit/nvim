return {
  {
    "NvChad/nvim-colorizer.lua",
    init = function()
      require("core.utils").lazy_load("nvim-colorizer.lua")
    end,
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },
  -- { "nvimdev/dashboard-nvim", enabled = false },
  { "folke/noice.nvim", opts = { lsp = { progress = { enabled = false } } } },
  { "folke/zen-mode.nvim", opts = {} },
  { "folke/twilight.nvim", opts = {} },
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
  -- dropbar
  {
    "Bekaboo/dropbar.nvim",
    enabled = false,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
  { "echasnovski/mini.indentscope", enabled = false },
  -- indent-blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = {
      enabled = false,
      indent = {
        char = "│",
        tab_char = "│",
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
      scope = { enabled = true },
    },
    keys = {
      { "<Leader>ue", "<cmd>IBLToggle<CR>", desc = "Toggle indentation lines" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")
      -- require("indent_blankline").setup(opts)
    end,
  },
  -- nvim-focus
  {
    "nvim-focus/focus.nvim",
    opts = {
      enable = false,
      autoresize = { enable = false },
    },
  },
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    enabled = true,
    opts = {
      options = {
        mode = "tabs", -- set to "tabs" to only show tabpages instead
        separator_style = "slant",
      },
    },
    -- config = function(_, opts)
    --   dofile(vim.g.base46_cache .. "bufferline")
    --   require("bufferline").setup(opts)
    -- end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.defaults["<leader>sr"] = { name = "+Replace word" }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      dofile(vim.g.base46_cache .. "notify")
      -- require("nvim-notify").setup()
    end,
  },
}
