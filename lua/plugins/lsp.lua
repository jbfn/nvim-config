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
      local ENABLED_LSPS = { "gopls", "basedpyright", "lua_ls", "jsonls", "bashls" }

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = ENABLED_LSPS,
        automatic_enable = { exclude = {} },
      })

      for _, lsp in pairs(ENABLED_LSPS) do
        if lsp == "lua_ls" then
          vim.lsp.config(lsp, {
            settings = { Lua = { workspace = { ignoreDir = {} } } } }
          )
        elseif lsp == "basedpyright" then
          vim.lsp.config(lsp, {
            settings = {
              basedpyright = {
                analysis = {
                  include = { "." },
                  exclude = {},
                }
              }
            }
          })
        elseif lsp == "gopls" then
          -- Enable semantic tokens
          vim.lsp.config(lsp, { settings = { gopls = { semanticTokens = true } } })
        elseif lsp == "jsonls" then
          vim.lsp.config(lsp, {
            settings = { json = { format = { enable = false } } },
            init_options = { provideFormatter = false },
          })
          vim.lsp.enable(lsp)
        end

        vim.lsp.enable(lsp)
      end


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

          -- Set up full semantic token support for gopls
          if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              range = true,
              legend = {
                tokenModifiers = semantic.tokenModifiers,
                tokenTypes = semantic.tokenTypes,
              },
            }
          end

          -- Set up auto-format on save
          if client.supports_method('textDocument/format') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                if vim.b[args.buf].disable_autoformat then
                  return
                end
                vim.lsp.buf.format({ bufnr = args.buf, client_id = client.id, timeout_ms = 3000 })
              end
            })
          end

          vim.api.nvim_buf_create_user_command(args.buf, "SaveWithoutFormatting", function()
            vim.b.disable_autoformat = true
            vim.cmd("write")
            vim.b.disable_autoformat = false
          end, { desc = "Save without formatting" })

          -- Set up LSP-based command maps
          local default_opts = { buffer = args.buf, noremap = true, silent = true }

          -- Hover
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, default_opts)

          -- Go to/from definition
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.definition, default_opts)
          -- attempt to "GOTO" in new window
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
          null_ls.builtins.formatting.prettier.with({ filetypes = { "json" } }),
        }
      })
    end,
  }
}
