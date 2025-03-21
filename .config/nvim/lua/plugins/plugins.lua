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
    {"terryma/vim-multiple-cursors"},


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
