return {
  {
    "Mythos-404/xmake.nvim",
    version = "^3",
    lazy = true,
    event = "BufReadPost xmake.lua",
    init = function()
      require("lualine").setup({
        sections = {
          lualine_y = {
            {
              function()
                if not vim.g.loaded_xmake then
                  return ""
                end
                local Info = require("xmake.info")
                if Info.mode.current == "" then
                  return ""
                end
                if Info.target.current == "" then
                  return "Xmake: Not Select Target"
                end
                return ("%s(%s)"):format(Info.target.current, Info.mode.current)
              end,
              cond = function()
                return vim.o.columns > 100
              end,
            },
          },
        },
      })
    end,
    config = true,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- fittencode ai
  {
    "luozhiya/fittencode.nvim",
    config = function()
      require("fittencode").setup()
    end,
  },

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

  { "mg979/vim-visual-multi" },

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
  -- fold code with za or zc
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = false,
      }
      local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
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
