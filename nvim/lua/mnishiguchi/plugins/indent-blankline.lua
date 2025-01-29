-- Add indentation guides on blank lines
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    local highlight = {
      "RainbowBrown",
      "RainbowBeige",
      "RainbowCoolGray",
      "RainbowSlateGray",
      "RainbowDarkSlate",
      "RainbowCharcoal",
    }

    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowBrown", { fg = "#8D6E63" })
      vim.api.nvim_set_hl(0, "RainbowBeige", { fg = "#A1887F" })
      vim.api.nvim_set_hl(0, "RainbowCoolGray", { fg = "#B0BEC5" })
      vim.api.nvim_set_hl(0, "RainbowSlateGray", { fg = "#78909C" })
      vim.api.nvim_set_hl(0, "RainbowDarkSlate", { fg = "#546E7A" })
      vim.api.nvim_set_hl(0, "RainbowCharcoal", { fg = "#37474F" })
    end)

    require("ibl").setup { indent = { highlight = highlight } }
  end,
}
