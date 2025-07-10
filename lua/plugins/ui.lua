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
          snippets = {
            supports_live = false,
            preview = "preview",
            format = function(item, picker)
              local name = Snacks.picker.util.align(item.name, picker.align_1 + 5)
              return {
                { name, item.ft == "" and "Conceal" or "DiagnosticWarn" },
                { item.description },
              }
            end,
            finder = function(_, ctx)
              local snippets = {}
              for _, snip in ipairs(require("luasnip").get_snippets().all) do
                snip.ft = ""
                table.insert(snippets, snip)
              end
              for _, snip in ipairs(require("luasnip").get_snippets(vim.bo.ft)) do
                snip.ft = vim.bo.ft
                table.insert(snippets, snip)
              end
              local align_1 = 0
              for _, snip in pairs(snippets) do
                align_1 = math.max(align_1, #snip.name)
              end
              ctx.picker.align_1 = align_1
              local items = {}
              for _, snip in pairs(snippets) do
                local docstring = snip:get_docstring()
                if type(docstring) == "table" then
                  docstring = table.concat(docstring)
                end
                local name = snip.name
                local description = table.concat(snip.description)
                description = name == description and "" or description
                table.insert(items, {
                  text = name .. " " .. description, -- search string
                  name = name,
                  description = description,
                  trigger = snip.trigger,
                  ft = snip.ft,
                  preview = {
                    ft = snip.ft,
                    text = docstring,
                  },
                })
              end
              return items
            end,
            confirm = function(picker, item)
              picker:close()
              --
              local expand = {}
              require("luasnip").available(function(snippet)
                if snippet.trigger == item.trigger then
                  table.insert(expand, snippet)
                end
                return snippet
              end)
              if #expand > 0 then
                vim.cmd(":startinsert!")
                vim.defer_fn(function()
                  require("luasnip").snip_expand(expand[1])
                end, 50)
              else
                Snacks.notify.warn("No snippet to expand")
              end
            end,
          },
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
        win = {
          preview = {
            wo = {
              foldcolumn = "0",
              number = false,
              relativenumber = false,
              signcolumn = "no",
            },
          },
        },
      },
      words = { enabled = false },
      image = {
        enabled = false,
        doc = {
          enabled = true,
          inline = false,
        },
      },
    },
    keys = {
      {
        "<leader>sP",
        function()
          Snacks.picker()
        end,
        desc = "Snacks picker",
      },
      {
        "<leader>fd",
        function()
          Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = " Files in Current Buffer Dir ",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        "<leader>fs",
        function()
          Snacks.picker.snippets()
        end,
        desc = "Snippets for current ft",
      },
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
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    enabled = true,
    opts = {
      options = {
        mode = "tabs", -- set to "tabs" to only show tabpages instead
        separator_style = "slant",
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
  },

  {
    "MaximilianLloyd/ascii.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
}
