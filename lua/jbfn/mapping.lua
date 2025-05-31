---------------------------------------------------------------------------------------------------
---------------------------------------   Custom Mappings  ----------------------------------------
---------------------------------------------------------------------------------------------------

local set = vim.keymap.set

-- Remap visual block mode to v
set("n", "v", "<C-v>", { noremap = false, desc = "Visual block mode" })

-- Unfold when finding next occurrence in searches
set("n", "n", "nzzzv", { noremap = true, desc = "Find next search occurrence" })

-- Copy and paste to/from system clipboard
set({ "n", "v", "x" }, "<leader>y", function()
  local unnamed = vim.fn.getreg('"')
  local unnamed_type = vim.fn.getregtype('"')
  vim.cmd('normal! "+y')
  vim.fn.setreg('"', unnamed, unnamed_type)
end, { noremap = true, desc = "Yank to system clipboard" })
set({ "n", "v", "x" }, "<leader>p", '"+p', { noremap = true, desc = "Paste from system clipboard" })

-- Use Alt + j/k for quickfix navigation
set("n", "<leader><leader>n", "<cmd>cnext<CR>", { desc = "Jump to next quickfix item" })
set("n", "<leader><leader>p", "<cmd>cprev<CR>", { desc = "Jump to previous quickfix item" })
set("n", "<M-k>", "[q", { desc = "Jump to previous quickfix item" })

-- Source current file
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source current file" })

-- Execute current line
set("n", "<leader>x", ":.lua<CR>", { desc = "Execute current line" })

-- Execute current selection
set("v", "<leader>x", ":lua<CR>", { desc = "Execute current visual selection" })

-- Delete buffer
set("n", "<leader>bd", "<cmd>bd!<CR>", { desc = "Delete current buffer" })

-- Create new tab
set("n", "<leader><leader>t", "<cmd>tabnew<CR>", { desc = "Create a new tab" })

-- Delete a tab
set("n", "<leader><leader>T", "<cmd>tabclose<CR>", { desc = "Delete current tab" })
