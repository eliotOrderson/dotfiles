local function load_project_rust_settings()
  local config_file = vim.fn.getcwd() .. "/rust-analyzer.json"
  if vim.fn.filereadable(config_file) == 1 then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and content then
      local json_str = table.concat(content, "\n")
      local success, decoded = pcall(vim.fn.json_decode, json_str)
      if success and type(decoded) == "table" then
        return decoded
      end
    end
  end
  return {}
end

local settings = {
  ["rust-analyzer"] = {
    inlayHints = {
      bindingModeHints = { enable = true },
      closingBraceHints = { minLines = 0 },
      closureCaptureHints = { enable = true },
      closureReturnTypeHints = { enable = "always" },
      expressionAdjustmentHints = {
        enable = "reborrow",
        hideOutsideUnsafe = true,
      },
      -- lifetimeElisionHints = { enable = "skip_trivial" },
      maxLength = vim.NIL,
      typing = { triggerChars = "=.{(><" },
    },
    -- check = {
    --   features = "binance",
    -- },
    -- diagnostics = {
    --   disabled = { "inactive-code" },
    -- },
  },
}


vim.g.rustaceanvim = {

  --- @type `rustaceanvim.tools.Opts`
  tools = {
    reload_workspace_from_cargo_toml = true,
    float_win_config = { border = { "", "", "", " ", "", "", "", " " } },
  },
  --- @type `rustaceanvim.lsp.ClientOpts`
  server = {
        settings = vim.tbl_deep_extend("force", settings,load_project_rust_settings())
    },
  --- @type `rustaceanvim.dap.Opts`
  dap = {},
}
return {
  -- remote development
  -- {
  --   "chipsenkbeil/distant.nvim",
  --   branch = "v0.3",
  --   config = function()
  --     require("distant"):setup()
  --   end,
  -- },
  -- live html
  -- {
  --   "barrett-ruth/live-server.nvim",
  --   build = "pnpm add -g live-server",
  --   cmd = { "LiveServerStart", "LiveServerStop" },
  --   config = true,
  -- },

  -- { "mg979/vim-visual-multi" },
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<up>", function()
        mc.lineAddCursor(-1)
      end)
      set({ "n", "x" }, "<down>", function()
        mc.lineAddCursor(1)
      end)
      set({ "n", "x" }, "<leader><up>", function()
        mc.lineSkipCursor(-1)
      end)
      set({ "n", "x" }, "<leader><down>", function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<C-n>", function()
        mc.matchAddCursor(1)
      end)

      set({ "v", "x" }, "<C-n>", function()
        mc.matchAddCursor(1)
      end)

      set({ "n", "x" }, "<leader>s", function()
        mc.matchSkipCursor(1)
      end)
      set({ "n", "x" }, "<leader>N", function()
        mc.matchAddCursor(-1)
      end)
      set({ "n", "x" }, "<leader>S", function()
        mc.matchSkipCursor(-1)
      end)

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },

  -- fast expand(select) text
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("wildfire").setup({
        surrounds = {
          { "(", ")" },
          { "{", "}" },
          { "<", ">" },
          { "[", "]" },
          { '"', '"' },
          { " ", " " },
          { "'", "'" },
          { ",", "," },
          { ", ", ", " },
        },
        keymaps = {
          init_selection = "<M-=>",
          node_incremental = "<M-=>",
          node_decremental = "<M-->",
        },
        filetype_exclude = { "qf" }, --keymaps will be unset in excluding filetypes
      })
    end,
  },
  -- -- fold code with za or zc
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        require("lspconfig")[ls].setup({
          capabilities = capabilities,
          -- you can add other fields for setting up lsp server in this table
        })
      end
      require("ufo").setup()
    end,
  },
}
