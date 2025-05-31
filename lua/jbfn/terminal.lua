vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom_term_open", { clear = true }),
  callback = function()
    vim.keymap.set("t", "<esc>", "<c-\\><c-n>", { desc = "Normal mode" })
    vim.cmd("startinsert")
  end,
})

vim.keymap.set("n", "<leader>t", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 20)
end, { desc = "Open bottom terminal window" })
