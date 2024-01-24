local myactions = {}

function myactions.send_to_qflist(prompt_bufnr)
  require("telescope.actions").send_to_qflist(prompt_bufnr)
  vim.api.nvim_command([[ botright copen ]])
end

function myactions.smart_send_to_qflist(prompt_bufnr)
  require("telescope.actions").smart_send_to_qflist(prompt_bufnr)
  vim.api.nvim_command([[ botright copen ]])
end

--- Scroll the results window up
---@param prompt_bufnr number: The prompt bufnr
function myactions.results_scrolling_up(prompt_bufnr)
  myactions.scroll_results(prompt_bufnr, -1)
end

--- Scroll the results window down
---@param prompt_bufnr number: The prompt bufnr
function myactions.results_scrolling_down(prompt_bufnr)
  myactions.scroll_results(prompt_bufnr, 1)
end

---@param prompt_bufnr number: The prompt bufnr
---@param direction number: 1|-1
function myactions.scroll_results(prompt_bufnr, direction)
  local status = require("telescope.state").get_status(prompt_bufnr)
  local default_speed = vim.api.nvim_win_get_height(status.results_win) / 2
  local speed = status.picker.layout_config.scroll_speed or default_speed

  require("telescope.actions.set").shift_selection(prompt_bufnr, math.floor(speed) * direction)
end

-- Custom pickers
local plugin_directories = function(opts)
  local actions = require("telescope.actions")
  local utils = require("telescope.utils")
  local dir = vim.fn.stdpath("data") .. "/lazy"

  opts = opts or {}
  opts.cmd = vim.F.if_nil(opts.cmd, {
    vim.o.shell,
    "-c",
    "find " .. vim.fn.shellescape(dir) .. " -mindepth 1 -maxdepth 1 -type d",
  })

  local dir_len = dir:len()
  opts.entry_maker = function(line)
    return {
      value = line,
      ordinal = line,
      display = line:sub(dir_len + 2),
    }
  end

  require("telescope.pickers")
    .new(opts, {
      layout_config = {
        width = 0.65,
        height = 0.7,
      },
      prompt_title = "[ Plugin directories ]",
      finder = require("telescope.finders").new_table({
        results = utils.get_os_command_output(opts.cmd),
        entry_maker = opts.entry_maker,
      }),
      sorter = require("telescope.sorters").get_fuzzy_file(),
      previewer = require("telescope.previewers.term_previewer").cat.new(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = require("telescope.actions.state").get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd.lcd(entry.value)
        end)
        return true
      end,
    })
    :find()
end

-- Custom window-sizes
---@param dimensions table
---@param size integer
---@return float
local function get_matched_ratio(dimensions, size)
  for min_cols, scale in pairs(dimensions) do
    if min_cols == "lower" or size >= min_cols then
      return math.floor(size * scale)
    end
  end
  return dimensions.lower
end

local function width_tiny(_, cols, _)
  return get_matched_ratio({ [180] = 0.27, lower = 0.37 }, cols)
end

local function width_small(_, cols, _)
  return get_matched_ratio({ [180] = 0.4, lower = 0.5 }, cols)
end

local function width_medium(_, cols, _)
  return get_matched_ratio({ [180] = 0.5, [110] = 0.6, lower = 0.75 }, cols)
end

local function width_large(_, cols, _)
  return get_matched_ratio({ [180] = 0.7, [110] = 0.8, lower = 0.85 }, cols)
end

-- Enable indent-guides in telescope preview
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  group = vim.api.nvim_create_augroup("rafi_telescope", {}),
  callback = function(args)
    if args.buf ~= vim.api.nvim_win_get_buf(0) then
      return
    end
    vim.opt_local.listchars = vim.wo.listchars .. ",tab:▏\\ "
    vim.opt_local.conceallevel = 0
    vim.opt_local.wrap = true
    vim.opt_local.list = true
    vim.opt_local.number = false
  end,
})

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "stevearc/aerial.nvim",
      "nvim-treesitter/nvim-treesitter",
      "jvgrootveld/telescope-zoxide",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      {
        "<leader>cg",
        "<cmd>Telescope aerial<cr>",
        desc = "Goto Symbol (Aerial)",
      },
      { "<localleader>r", "<cmd>Telescope resume initial_mode=normal<CR>", desc = "Resume last" },
      { "<localleader>R", "<cmd>Telescope pickers<CR>", desc = "Pickers" },
      { "<localleader>n", plugin_directories, desc = "Plugins" },
      { "<localleader>;", "<cmd>Telescope command_history<CR>", desc = "Command history" },
      { "<localleader>h", "<cmd>Telescope highlights<CR>", desc = "Highlights" },
      { "<localleader>:", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<localleader>/", "<cmd>Telescope search_history<CR>", desc = "Search history" },
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        "<localleader>z",
        function()
          require("telescope").extensions.zoxide.list({
            layout_config = { width = 0.5, height = 0.6 },
          })
        end,
        desc = "Zoxide (MRU)",
      },
    },
    opts = function()
      local transform_mod = require("telescope.actions.mt").transform_mod
      local actions = require("telescope.actions")

      -- Transform to Telescope proper actions.
      myactions = transform_mod(myactions)

      -- Clone the default Telescope configuration and enable hidden files.
      local has_ripgrep = vim.fn.executable("rg") == 1
      local vimgrep_args = {
        unpack(require("telescope.config").values.vimgrep_arguments),
      }
      table.insert(vimgrep_args, "--hidden")
      table.insert(vimgrep_args, "--follow")
      -- table.insert(vimgrep_args, '--no-ignore-vcs')
      table.insert(vimgrep_args, "--glob")
      table.insert(vimgrep_args, "!**/.git/*")

      local find_args = {
        "rg",
        "--vimgrep",
        "--files",
        "--follow",
        "--hidden",
        -- '--no-ignore-vcs',
        "--smart-case",
        "--glob",
        "!**/.git/*",
      }

      return {
        defaults = {
          sorting_strategy = "ascending",
          cache_picker = { num_pickers = 3 },

          prompt_prefix = "  ", -- ❯  
          selection_caret = "▍ ",
          multi_icon = " ",

          path_display = { "truncate" },
          file_ignore_patterns = { "node_modules" },
          set_env = { COLORTERM = "truecolor" },
          vimgrep_arguments = has_ripgrep and vimgrep_args or nil,

          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
					-- stylua: ignore
					mappings = {

						i = {
							['jj'] = { '<Esc>', type = 'command' },

							['<Tab>'] = actions.move_selection_worse,
							['<S-Tab>'] = actions.move_selection_better,
							['<C-u>'] = actions.results_scrolling_up,
							['<C-d>'] = actions.results_scrolling_down,

							['<C-q>'] = myactions.smart_send_to_qflist,

							['<C-n>'] = actions.cycle_history_next,
							['<C-p>'] = actions.cycle_history_prev,

							['<C-b>'] = actions.preview_scrolling_up,
							['<C-f>'] = actions.preview_scrolling_down,
						},

						n = {
							['q']     = actions.close,
							['<Esc>'] = actions.close,

							['<Tab>'] = actions.move_selection_worse,
							['<S-Tab>'] = actions.move_selection_better,
							['<C-u>'] = myactions.results_scrolling_up,
							['<C-d>'] = myactions.results_scrolling_down,

							['<C-b>'] = actions.preview_scrolling_up,
							['<C-f>'] = actions.preview_scrolling_down,

							['<C-n>'] = actions.cycle_history_next,
							['<C-p>'] = actions.cycle_history_prev,

							['*'] = actions.toggle_all,
							['u'] = actions.drop_all,
							['J'] = actions.toggle_selection + actions.move_selection_next,
							['K'] = actions.toggle_selection + actions.move_selection_previous,
							[' '] = {
								actions.toggle_selection + actions.move_selection_next,
								type = 'action',
								opts = { nowait = true },
							},

							['sv'] = actions.select_horizontal,
							['sg'] = actions.select_vertical,
							['st'] = actions.select_tab,

							['w'] = myactions.smart_send_to_qflist,
							['e'] = myactions.send_to_qflist,

							['!'] = actions.edit_command_line,

							['t'] = function(...)
								return require('trouble.providers.telescope').open_with_trouble(...)
							end,

							['p'] = function()
								local entry = require('telescope.actions.state').get_selected_entry()
								require('rafi.lib.preview').open(entry.path)
							end,
						},

					},
          border = {},
        },
        pickers = {
          buffers = {
            sort_lastused = true,
            sort_mru = true,
            show_all_buffers = true,
            ignore_current_buffer = true,
            layout_config = { width = width_large, height = 0.7 },
            mappings = {
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          find_files = {
            find_command = has_ripgrep and find_args or nil,
          },
          live_grep = {
            dynamic_preview_title = true,
          },
          colorscheme = {
            enable_preview = true,
            layout_config = { preview_width = 0.7 },
          },
          highlights = {
            layout_config = { preview_width = 0.7 },
          },
          vim_options = {
            theme = "dropdown",
            layout_config = { width = width_medium, height = 0.7 },
          },
          command_history = {
            theme = "dropdown",
            layout_config = { width = width_medium, height = 0.7 },
          },
          search_history = {
            theme = "dropdown",
            layout_config = { width = width_small, height = 0.6 },
          },
          spell_suggest = {
            theme = "cursor",
            layout_config = { width = width_tiny, height = 0.45 },
          },
          registers = {
            theme = "cursor",
            layout_config = { width = 0.35, height = 0.4 },
          },
          oldfiles = {
            theme = "dropdown",
            previewer = false,
            layout_config = { width = width_medium, height = 0.7 },
          },
          lsp_definitions = {
            layout_config = { width = width_large, preview_width = 0.55 },
          },
          lsp_implementations = {
            layout_config = { width = width_large, preview_width = 0.55 },
          },
          lsp_references = {
            layout_config = { width = width_large, preview_width = 0.55 },
          },
          lsp_code_actions = {
            theme = "cursor",
            previewer = false,
            layout_config = { width = 0.3, height = 0.4 },
          },
          lsp_range_code_actions = {
            theme = "cursor",
            previewer = false,
            layout_config = { width = 0.3, height = 0.4 },
          },
        },
        extensions = {
          zoxide = {
            prompt_title = "[ Zoxide directories ]",
            mappings = {
              default = {
                action = function(selection)
                  vim.cmd.lcd(selection.path)
                end,
                after_action = function(selection)
                  vim.notify("Current working directory set to '" .. selection.path .. "'", vim.log.levels.INFO)
                end,
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      require("telescope").setup(opts)
      require("telescope").load_extension("aerial")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("luasnip")

      -- Highlights
      local fg_bg = require("utils").fg_bg
      local bg = require("utils").bg
      local fg = require("utils").fg

      local colors = require("colorscheme.nord.named_colors")

      fg_bg("TelescopePromptPrefix", colors.red, colors.black2)

      bg("TelescopeNormal", colors.darker_black)

      fg_bg("TelescopePreviewTitle", colors.black, colors.green)

      fg_bg("TelescopePromptTitle", colors.black, colors.red)

      fg_bg("TelescopeSelection", colors.white, colors.black2)

      fg_bg("TelescopeBorder", colors.darker_black, colors.darker_black)
      fg_bg("TelescopePromptBorder", colors.black2, colors.black2)
      fg_bg("TelescopePromptNormal", colors.white, colors.black2)
      fg_bg("TelescopeResultsTitle", colors.darker_black, colors.darker_black)
      fg_bg("TelescopePromptPrefix", colors.red, colors.black2)
    end,
  },
  {
    "benfowler/telescope-luasnip.nvim",
  },

  -- add telescope-fzf-native
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },

  {
    "stevearc/aerial.nvim",
    config = true,
  },
}
