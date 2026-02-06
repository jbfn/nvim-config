return {
  {
    "tpope/vim-fugitive",
    config = function()
      -- Go to the original file from a git fugitive view (such as a diff index)
      vim.keymap.set("n", "<leader>ge", "<cmd>Gedit<CR>", { desc = "Go to file on disk" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame_formatter = "<author_time:%b %d, %Y (%a)>; <author>; \n<summary>",
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>gs', gitsigns.stage_hunk)
        map('n', '<leader>gr', gitsigns.reset_hunk)

        map('v', '<leader>gs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('v', '<leader>gr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('n', '<leader>gS', gitsigns.stage_buffer)
        map('n', '<leader>gR', gitsigns.reset_buffer)
        map('n', '<leader>gp', gitsigns.preview_hunk_inline)

        map('n', '<leader>gb', function() gitsigns.blame_line({ full = true }) end)

        map('n', '<leader>gd', function() gitsigns.diffthis('~') end)

        map('n', '<leader>gQ', function() gitsigns.setqflist('all') end)
        map('n', '<leader>gq', gitsigns.setqflist)

        -- Toggles




        vim.keymap.set("n", "<leader>gb", function()
          local file = vim.fn.expand('%:p')
          local line = vim.fn.line('.')
          local blame_line = vim.fn.systemlist(string.format("git blame -c -L %d,%d %s", line, line, file))[1]

          local sha = blame_line:match("^([0-9a-f]+)")
          if not sha then
            print("Unable to extract commit SHA from blame line.")
            return
          end

          local author = vim.fn.system("git show -s --format='%an <%ae>' " .. sha):gsub("\n", "")
          local date = vim.fn.system("git show -s --format='%ad' --date=format:'%b %d %Y, %a' " .. sha):gsub("\n", "")
          local header = string.format("%s (%s) by %s", sha:sub(1, 8), date, author)
          local full_msg = vim.fn.systemlist("git show -s --format=%B " .. sha)

          -- Insert header
          table.insert(full_msg, 1, "")
          table.insert(full_msg, 1, header)

          -- Floating window
          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, full_msg)
          vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })

          local width = math.min(100, math.floor(vim.o.columns * 0.9))
          local height = math.min(#full_msg + 2, math.floor(vim.o.lines * 0.4))
          local row = math.floor((vim.o.lines - height) / 2)
          local col = math.floor((vim.o.columns - width) / 2)

          vim.api.nvim_open_win(buf, true, {
            relative = 'editor',
            row = row,
            col = col,
            width = width,
            height = height,
            border = 'rounded',
            style = 'minimal',
            focusable = true,
          })
        end, { desc = "Show full git commit message (no diffs)" })
      end

    }
  }
}
