local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fg", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "[f]ind [g]rep" })

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[f]ind [f]iles" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[f]ind [b]uffers" })
vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "[f]ind [m]arks" })
vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "[f]ind [r]egisters" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[f]ind [h]elp" })
vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "[f]ind [q]uickfix items " })
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] recently opened files" })

vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "[g]it [f]iles" })
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "[g]it [b]ranches" })
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "[g]it [c]ommits" })

