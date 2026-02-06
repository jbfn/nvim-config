return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = require("telescope.themes").get_ivy {},
      pickers = {
        find_files = {
          hidden = true,
        },
        buffers = {
          mappings = {
            n = {
              ["dd"] = require("telescope.actions").delete_buffer,
            }
          }
        }
      },
    },
    init = function()
      local builtin = require('telescope.builtin')
      local set = vim.keymap.set

      -- Pure telescope picker keymaps
      set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      set('n', '<leader>fw', builtin.live_grep, { desc = 'Live grep' })
      set('n', '<leader>fiw', function()
        require("telescope.builtin").live_grep({ default_text = vim.fn.expand('<cword>') })
      end, { desc = 'Live grep word under cursor' })
      set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help tags' })
      set('n', '<leader>fg', builtin.git_branches, { desc = 'Find help tags' })
      set('n', '<leader>fr', builtin.lsp_references, { desc = 'Find lsp references' })
    end,
  },
}
