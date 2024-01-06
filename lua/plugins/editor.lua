local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local totalLines = vim.api.nvim_buf_line_count(0)
  local foldedLines = endLnum - lnum
  local suffix = ("  %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  local rAlignAppndx = math.max(math.min(0, width - 1) - curWidth - sufWidth, 0)
  suffix = (" "):rep(rAlignAppndx) .. suffix
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end
return {
  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
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
  {
    "kevinhwang91/nvim-ufo",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
      {
        "luukvbaal/statuscol.nvim",
        lazy = false,
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          })
        end,
      },
    },
    keys = {
      { "zc" },
      { "zo" },
      { "zC" },
      { "zO" },
      { "za" },
      { "zA" },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        desc = "Open Folds Except Kinds",
      },
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open All Folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close All Folds",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        desc = "Close Folds With",
      },
      {
        "zp",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek Fold",
      },
    },
    opts = {
      -- Option 3: treesitter as a main provider instead
      -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
      -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
      fold_virt_text_handler = handler,
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      require("ufo").setup(opts)
    end,
  },

  -- Spectre: search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>srs", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },
  -- Zk
  {
    "mickael-menu/zk-nvim",
    name = "zk",
    ft = "markdown",
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkMatch" },
    keys = {
      { "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = "Zk New" },
      { "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", desc = "Zk Notes" },
      { "<leader>zt", "<Cmd>ZkTags<CR>", desc = "Zk Tags" },
      {
        "<leader>zf",
        "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>",
        desc = "Zk Search",
      },
      { "<leader>zf", ":'<,'>ZkMatch<CR>", mode = "x", desc = "Zk Match" },
      { "<leader>zb", "<Cmd>ZkBacklinks<CR>", desc = "Zk Backlinks" },
      { "<leader>zl", "<Cmd>ZkLinks<CR>", desc = "Zk Links" },
    },
    opts = { picker = "telescope" },
  },

  -- FZF
  { "junegunn/fzf", build = "./install --bin" },

  -- Twig
  { "nelsyeung/twig.vim" },

  -- phpactor
  { "phpactor/phpactor" },

  -- Chrome Bookmarks
  {
    "dhruvmanila/browser-bookmarks.nvim",
    version = "*",
    -- Only required to override the default options
    opts = {
      -- Override default configuration values
      selected_browser = "chrome",
      url_open_command = "xdg-open",
      debug = true,
    },
    dependencies = {
      --   -- Only if your selected browser is Firefox, Waterfox or buku
      --   'kkharji/sqlite.lua',
      --
      --   -- Only if you're using the Telescope extension
      "nvim-telescope/telescope.nvim",
    },
  },
}
