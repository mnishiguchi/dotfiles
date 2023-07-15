-- Highlight, list and search todo comments
return {
  "folke/todo-comments.nvim",
  config = function()
    require("todo-comments").setup()
  end,
  dependencies = { "nvim-lua/plenary.nvim" },
}
