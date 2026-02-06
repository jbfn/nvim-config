return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "c",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "vim",
      "vimdoc",
    },
  },
  build = ":TSUpdate",
  config = function()
    local ts = vim.treesitter

    -- Start treesitter for custom python capture group highlighting.
    vim.api.nvim_create_autocmd('FileType', {
      desc = "Start treesitter highlighting",
      pattern = { "python", "go" },
      callback = function(args)
        if not ts.highlighter.active[args.buf] then
          ts.start(args.buf, args.match)
        end
      end
    })
  end
}
