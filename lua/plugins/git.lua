return {
  "tpope/vim-fugitive",
  config = function()
    -- Go to the original file from a git fugitive view (such as a diff index)
    vim.keymap.set("n", "<leader>ge", "<cmd>Gedit<CR>", { desc = "Go to file on disk" })
  end,
}
