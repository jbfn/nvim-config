-- Show global status bar rather than per-window
vim.opt.laststatus = 3

vim.opt.statusline = "%{FugitiveStatusline()}"

vim.opt.winbar = "%=%m %f"

vim.api.nvim_set_hl(0, "WinBar", { fg = "White" })

-- Set window separator
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "None", fg = "White" })

-- Window resizing
vim.keymap.set("n", "<C-W>_", "10<C-W>_")
vim.keymap.set("n", "<C-W>+", "10<C-W>+")
vim.keymap.set("n", "<C-W><", "10<C-W><")
vim.keymap.set("n", "<C-W>>", "10<C-W>>")

-- Enable cursor line highlighting only for inactive window
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.wo.cursorline = true
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Move window to a small, top-right overlay
vim.api.nvim_create_user_command("CreateFloatingWindow", function()
  local buf = vim.api.nvim_get_current_buf()
  local large_win = vim.api.nvim_get_current_win()

  local ui = vim.api.nvim_list_uis()[1]
  local width = 80
  local height = 12
  local row = 1
  local col = ui.width - width - 3

  -- Re-open the buffer in a floating window
  _G.overlay_win_id = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded"
  })

  -- Switch og window to empty buffer if it's the last window, otherwise close it
  local scratch = vim.api.nvim_create_buf(false, true)
  vim.bo[scratch].buftype = "nofile"
  vim.bo[scratch].bufhidden = "wipe"
  vim.bo[scratch].swapfile = false
  vim.bo[scratch].buflisted = false
  vim.api.nvim_win_set_buf(large_win, scratch)

  -- vim.api.nvim_win_hide(large_win)
end, {})

vim.api.nvim_create_user_command("ToggleFloatingWindow", function()
  local og_win = vim.api.nvim_get_current_win()
  if og_win == _G.overlay_win_id then
    vim.api.nvim_win_hide(og_win)
  else
    vim.api.nvim_set_current_win(_G.overlay_win_id)
  end
end, {})

vim.keymap.set("n", "<leader>wO", ":CreateFloatingWindow<CR>", { desc = "Make window overlay" })
vim.keymap.set("n", "<leader>wo", function()
  if _G.overlay_win_id then
    vim.api.nvim_set_current_win(_G.overlay_win_id)
  end
end, { desc = "Focus on overlay window" })
