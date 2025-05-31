return {
  "natecraddock/workspaces.nvim",
  config = function()
    local ts = require("telescope")
    local ws = require("workspaces")
    ws.setup({
      -- change directory only for the current window
      cd_type = "local",

      -- auto-activate workspace when opening neovim in a workspace dir
      auto_open = true,

      -- auto-activate workspace when changing dir not via this plugin (e.g. `:e`)
      auto_dir = false,

      -- enable info-level notifications after adding or removing a workspace
      notify_info = true,

      -- hooks to run after specific actions
      hooks = {
        open = function()
          require("telescope.builtin").find_files()
        end,
      },
    })

    -- Set up telescope pickers
    ts.load_extension("workspaces")

    vim.keymap.set('n', '<leader>fp', function()
      ts.extensions.workspaces.workspaces()
    end, { desc = "Find workspaces (projects)" }
    )

    vim.keymap.set('n', '<leader>en', function()
      ws.open("nvim")
    end, { desc = 'Find NeoVim config' })
  end
}
