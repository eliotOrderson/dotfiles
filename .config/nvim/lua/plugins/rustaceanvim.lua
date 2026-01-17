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

-- local settings = {
--   ["rust-analyzer"] = {
--     inlayHints = {
--       bindingModeHints = { enable = true },
--       closingBraceHints = { minLines = 0 },
--       closureCaptureHints = { enable = true },
--       closureReturnTypeHints = { enable = "always" },
--       expressionAdjustmentHints = {
--         enable = "reborrow",
--         hideOutsideUnsafe = true,
--       },
--       -- lifetimeElisionHints = { enable = "skip_trivial" },
--       maxLength = vim.NIL,
--       typing = { triggerChars = "=.{(><" },
--     },
--   },
-- }

-- vim.g.rustaceanvim = {
--
--   --- @type `rustaceanvim.tools.Opts`
--   tools = {
--     reload_workspace_from_cargo_toml = true,
--     float_win_config = { border = { "", "", "", " ", "", "", "", " " } },
--   },
--   --- @type `rustaceanvim.lsp.ClientOpts`
--   server = {
--     settings = vim.tbl_deep_extend("force", settings, load_project_rust_settings()),
--   },
--   --- @type `rustaceanvim.dap.Opts`
--   dap = {},
-- }

local function load_rust_analyzer_json()
  local json_path = vim.fn.getcwd() .. "/rust-analyzer.json"
  if vim.fn.filereadable(json_path) == 1 then
    local ok, json = pcall(vim.fn.readfile, json_path)
    if ok then
      local decoded = vim.fn.json_decode(table.concat(json, "\n"))
      return decoded or {}
    end
  end
  return {}
end

vim.g.rustaceanvim = {
  server = {
    auto_attach = true,
    settings = {
      ["rust-analyzer"] = vim.tbl_deep_extend(
        "force",
        {
          procMacro = { enable = true },
          cargo = {
            allFeatures = true,
            buildScripts = { enable = true },
          },
        },
        load_rust_analyzer_json()
      ),
    },
  },
}
return {

  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
}
