-- Visualize the undo history
return {
  "mbbill/undotree",
  config = function()
    vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "toggle [u]ndotree" })
  end,
}
