-- Manage project marks
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    -- Mark a file that I want to revisit later on
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

    -- View all project marks
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    -- Revisit a marked project file
    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = 'Jump to 1st harpoon mark' })
    vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end, { desc = 'Jump to 2nd harpoon mark' })
    vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end, { desc = 'Jump to 3rd harpoon mark' })
  end,
  dependencies = { "nvim-lua/plenary.nvim" }
}
