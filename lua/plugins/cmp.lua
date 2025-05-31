return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "onsails/lspkind.nvim" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
    { "ray-x/lsp_signature.nvim", event = "InsertEnter" },
    { "L3MON4D3/LuaSnip",         build = "make install_jsregexp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "tzachar/cmp-tabnine",      build = "./install.sh",         requires = { "hrsh7th/nvim-cmp" } },
  },
  config = function()
    require("lspkind").init()

    vim.opt.pumheight = 7

    local cmp = require("cmp")
    local default_completeopt = "menu, menuone, preview, noinsert"
    cmp.setup({
      sources = {
        { name = "nvim_lsp" },
        { name = "cmp_tabnine" },
        { name = "path" },
        { name = "buffer" },
      },
      mapping = {
        ["<C-n>"] = cmp.mapping(
          cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          { "i", "c" }
        ),
        ["<C-p>"] = cmp.mapping(
          cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          { "i", "c" }
        ),
        ["<C-y>"] = cmp.mapping(
          cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
          { "i", "c" }
        ),
      },
      completion = { completeopt = default_completeopt },
      -- Enable luasnip to handle snipped expansion for nvim-cmp
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
    })

    -- Configure nvim-cmp for NeoVim's cmdline mode
    cmp.setup.cmdline(":", {
      sources = {
        { name = "cmdline" },
        { name = "path" },
      },
      completion = { completeopt = default_completeopt },
    })

    cmp.setup.cmdline("/", {
      sources = {
        { name = "buffer" },
      },
      completion = { completeopt = default_completeopt },
    })

    local signature = require("lsp_signature")
    signature.setup({
      hint_enable = false,
      hint_prefix = ""
    })

    -- Enable tabnine completion
    local tabnine = require("cmp_tabnine.config")
    tabnine:setup({
      max_lines = 1000,
      max_num_results = 7,
      sort = true,
      run_on_every_keystroke = true,
      snippet_placeholder = '..',
      ignored_file_types = {
        vtk = true,
        pvtp = true,
        csv = true,
      },
      show_prediction_strength = false,
      min_percent = 0
    })

    local ls = require("luasnip")
    ls.config.set_config({
      history = false,
      updateevents = { "TextChanged", "TextChangedI" },
    })

    vim.keymap.set({ "i", "s" }, "<c-k>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { desc = "Jump into or expand" })
    vim.keymap.set({ "i", "s" }, "<c-j>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true, desc = "Jump back" })
  end
}
