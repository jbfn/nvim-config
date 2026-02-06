return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "moon",
    styles = {
      keywords = { italic = false },
    },
    on_colors = function(colors)
      colors.bg = "#1b1d2b" -- background colour
    end,

  },
  config = function(_, opts)
    require("tokyonight").setup(opts)

    vim.cmd("colorscheme tokyonight")

    local hl = vim.api.nvim_set_hl

    -- Set line wrap column color
    hl(0, "ColorColumn", { bg = "#1f2130" })

    -- Override default capture group colours
    hl(0, "ParamBlue", { fg = "#9CDCFE" })
    hl(0, "ClassGreen", { fg = "#4EC9B0" })

    -- Generic
    hl(0, "@variable.parameter", { link = "ParamBlue" })
    hl(0, "@lsp.type.parameter", { link = "ParamBlue" })
    hl(0, "@lsp.type.class", { link = "ClassGreen" })
    hl(0, "@lsp.type.namespace", { link = "ClassGreen" })

    hl(0, "@lsp.type.parameter", { link = "ParamBlue" })
    hl(0, "@variable.parameter", { link = "ParamBlue" })
    hl(0, "@variable.member", { link = "ParamBlue" })
    hl(0, "@variable", { link = "ParamBlue" })

    -- Python
    hl(0, "@lsp.type.class.python", { link = "ClassGreen" })
    hl(0, "@lsp.type.namespace.python", { link = "ClassGreen" })

    hl(0, "@lsp.type.parameter.python", { link = "ParamBlue" })
    hl(0, "@variable.parameter.python", { link = "ParamBlue" })
    hl(0, "@variable.member.python", { link = "ParamBlue" })
    hl(0, "@variable.python", { link = "ParamBlue" })

    -- Set custom capture group colours (doesn't do anything currently, but keep as example
    -- for future custom capture groups.

    hl(0, "@jbfn", { link = "ParamBlue" })
    hl(0, "@jbfn.type.parameter.self.python", { link = "ParamBlue" })
  end
}
