-- Add indentation guides on blank lines
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    require("ibl").setup()
  end,
  opts = {},
}
