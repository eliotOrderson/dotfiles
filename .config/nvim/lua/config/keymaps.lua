-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")

-- DO NOT USE THIS IN YOU OWN CONFIG!!
-- use `vim.keymap.set` instead
local map = Util.safe_keymap_set
local opts = { silent = true }

local function inmap(lhs, rhs, visual_same_or_other, esc_mode)
  local cmd = string.gsub(
    [[
    imap <silent> $lhs <c-o>$rhs
    nmap <silent> $lhs $rhs
    ]],
    "%$(%w+)",
    { lhs = lhs, rhs = rhs }
  )
  if esc_mode then
    cmd = string.gsub(cmd, "<c%-o>", "<esc>")
  end

  if type(visual_same_or_other) == "boolean" then
    if visual_same_or_other then
      cmd = cmd
        .. string.gsub(
          [[
          vmap <silent> $lhs $rhs
        ]],
          "%$(%w+)",
          { lhs = lhs, rhs = rhs }
        )
    end
  elseif type(visual_same_or_other) == "string" then
    cmd = cmd
      .. string.gsub(
        [[
          vmap <silent> $lhs $rhs
        ]],
        "%$(%w+)",
        { lhs = lhs, rhs = visual_same_or_other }
      )
  end
  vim.cmd(cmd)
end

-- close buffer
map("n", "<m-q>", function()Snacks.bufdelete() end, { desc = "Delete Buffer" })

-- basic map
map("i", "jj", "<esc>", opts)
map("i", "kk", "<esc>", opts)
map("t", "jj", "<C-\\><C-n>", opts)

map("n", "<leader>h", ":noh<cr>", { desc = "Drop Highlight" })
-- map("n", "<S-k>", vim.lsp.buf.hover, { desc = "Variable Hover" })
-- map("n", "<leader>p", ":Telescope projects<cr>", { desc = "Open Recent Projects" })

-- terminal
local lazyterm = function()
  Util.terminal(nil, { cwd = Util.root() })
end
map("n", "<c-\\>", lazyterm, { desc = "Terminal (root dir)" })
map("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })

map("n", "<enter>", "mao<esc>0<S-d>`a<cmd>delmarks a<cr>", { desc = "Add new line below" })

-- fast move curosr
inmap("<a-l>", "$", "$h", false)
inmap("<a-h>", "^", "^", false)

-- paste
inmap("<c-v>", "pa", false, true)

-- open file tree
inmap("<m-e>", "<leader>e", false, true)

-- fast goto defintion
inmap("<c-q>", "<c-o>", false, false)
inmap("<c-e>", "gd", false, false)

-- swap buffer
inmap("<s-m-h>", ":BufferLineMovePrev<cr>", false, true)
inmap("<s-m-l>", ":BufferLineMoveNext<cr>", false, true)

-- comment code
inmap("<c-/>", "gcl", "gc", false)
