-- Git,
return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = ":Git status" })
    vim.keymap.set("n", "<leader>gw", ":Gwrite<CR>", { desc = ":Git write (add current file)" })
    vim.keymap.set("n", "<leader>gr", ":Gread<CR>", { desc = ":Git read (replace current file)" })
  end,
}
