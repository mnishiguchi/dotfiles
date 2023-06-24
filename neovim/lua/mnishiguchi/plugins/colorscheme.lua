return {
  "marko-cerovac/material.nvim",
  lazy = false,   -- load this during startup
  priority = 1000, -- load this before all the other start plugins
  init = function()
    vim.g.material_style = "deep ocean"
  end,
  config = function()
    require("material").setup({
      -- plugins that you use to highlight them
      plugins = {
        "gitsigns",
        "indent-blankline",
        "nvim-cmp",
        "telescope",
        "which-key",
      },
    })

    local colorscheme = "material"
    local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
    if not status_ok then
      print("colorscheme " .. colorscheme .. " not found")
      return
    end
  end,
}
