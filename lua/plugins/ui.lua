return {
  -- { "nvimdev/dashboard-nvim", enabled = false },
  {
    "folke/noice.nvim",
    lsp = {
      progress = {
        enabled = true,
      },
    },
    presets = {
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    opts = {
      routes = {
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = {
            skip = true,
          },
        },
      },
    },
  },
  { "folke/zen-mode.nvim", opts = {} },
  { "folke/twilight.nvim", opts = {} },
  -- nvim-bqf
  {
    "folke/snacks.nvim",
    opts = {
      -- enable the snacks feature
      picker = {
        prompt = "   ",
        enabled = true,
        layout = {
          -- The default layout for "telescopy" pickers, e.g. `files`, `commands`, ...
          -- It will not override non-standard pickers, e.g. `explorer`, `lines`, ...
          preset = function()
            return vim.o.columns >= 120 and "telescope" or "vertical"
          end,
        },
        layouts = {
          telescope = {
            -- Copy from https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#telescope
            reverse = false,
            layout = {
              box = "horizontal",
              backdrop = false,
              height = 0.9,
              width = 0.9,
              border = "none",
              {
                box = "vertical",
                {
                  win = "input",
                  height = 1,
                  border = "single",
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
                {
                  win = "list",
                  border = "rounded",
                  title = " Results ",
                  title_pos = "center",
                },
              },
              {
                win = "preview",
                title = "{preview:Preview}",
                width = 0.51, -- Change the preview width
                border = "rounded",
                title_pos = "center",
              },
            },
          },
        },
        sources = {
          files = {},
          explorer = {
            layout = {
              layout = {
                position = "left",
              },
            },
          },
          lines = {
            layout = {
              preset = function()
                return vim.o.columns >= 120 and "telescope" or "vertical"
              end,
            },
          },
        },
      },
      words = { enabled = false },
      image = { enabled = true },
    },
  },
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
  { "echasnovski/mini.indentscope", enabled = true },
  -- indent-blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = {
      enabled = true,
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
          "NvimTree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
      scope = { enabled = false },
    },
    keys = {
      { "<Leader>ue", "<cmd>IBLToggle<CR>", desc = "Toggle indentation lines" },
    },
    config = function(_, opts)
      -- dofile(vim.g.base46_cache .. "blankline")
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
        separator_style = "thin",
        offsets = {
          {
            filetype = "snacks_picker_list",
            text = "File Explorer",
            highlight = "NeoTreeOffset",
            text_align = "center",
          },
        },
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
      -- dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      -- dofile(vim.g.base46_cache .. "notify")
      -- require("nvim-notify").setup()
    end,
  },
}
