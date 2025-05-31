return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        -- Ensure nvim runtime is known
        "folke/lazydev.nvim",
        priority = 100,
        ft = "lua", -- only load on lua files
        config = function()
          require("lazydev").setup({
            library = {
              { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            }
          })
        end,
      },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "basedpyright", "lua_ls", "jsonls", "bashls" },
        automatic_enable = true,
      })

      -- Set up diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        update_in_insert = true,
        signs = true,
        underline = true,
        severity_sort = true,
      })

      -- Set up autocommands
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Set up auto-format on save
          if client.supports_method('textDocument/format') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, client_id = client.id })
              end
            })
          end

          -- Set up LSP-based command maps
          local default_opts = { buffer = args.buf, noremap = true, silent = true }

          -- Hover
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, default_opts)

          -- Go to/from definition
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.definition, default_opts)
          -- vim.keymap.set('n', '<C-K>', function()
          --   vim.api.nvim_command("vsplit")
          --   vim.api.nvim_command("wincmd l")
          --   vim.lsp.buf.definition()
          -- end, default_opts)
          vim.keymap.set('n', '<C-j>', "<C-o>", default_opts)
        end,
      })
    end,
  },
  {
    -- Set up formatting, analysis, and linting as language servers
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.diagnostics.mypy,
        }
      })
    end,
  }
}
