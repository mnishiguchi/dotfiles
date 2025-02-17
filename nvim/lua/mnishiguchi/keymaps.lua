-- https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings-set
local keymap = vim.keymap.set
-- https://neovim.io/doc/user/lua-guide.html#lua-guide-commands
local command = vim.api.nvim_create_user_command

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
keymap({ "n", "v" }, "<Space>", "<Nop>", { desc = "Unbind space" })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- File Explorer
keymap("n", "<leader>e", ":Ex<CR>", { desc = "Open file explorer" })

-- Visual Mode Line Movements
keymap("v", "J", ":move '>+1<CR>gv=gv", { desc = "Move lines down" })
keymap("v", "K", ":move '<-2<CR>gv=gv", { desc = "Move lines up" })
keymap("v", "H", "<gv", { desc = "Indent left (repeatable)" })
keymap("v", "L", ">gv", { desc = "Indent right (repeatable)" })
keymap("v", "<", "<gv", { desc = "Indent left (repeatable)" })
keymap("v", ">", ">gv", { desc = "Indent right (repeatable)" })

-- Cursor Management
keymap("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
keymap("n", "j", "jzz", { desc = "Move down (centered)" })
keymap("n", "k", "kzz", { desc = "Move up (centered)" })
keymap("n", "<Up>", "<Up>zz", { desc = "Move up (centered)" })
keymap("n", "<Down>", "<Down>zz", { desc = "Move down (centered)" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })

-- Search Enhancements
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Disable Accidental Commands
keymap({ "n", "v" }, "<leader>p", "<Nop>", { desc = "Disable accidental pasting with leader" })

-- Yank and Paste Improvements
keymap("v", "p", '"_dP', { desc = "Paste over selection without yanking" })
keymap("n", "<leader>d", '"_d', { desc = "Delete without yanking" })
keymap("v", "<leader>d", '"_d', { desc = "Delete without yanking" })
keymap("n", "x", '"_x', { desc = "Delete character without yanking" })

-- Find and Replace
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/___/cgI<Left><Left><Left><Left>]], {
  desc = "Substitute word under cursor",
})

-- Tag Management
keymap("n", "<leader>ct", function()
  local output = vim.fn.system("ctags -R .")
  if vim.v.shell_error == 0 then
    vim.notify("Tags generated", vim.log.levels.INFO)
  else
    vim.notify("Error generating tags: " .. output, vim.log.levels.ERROR)
  end
end, { desc = "Generate tags (ctags)" })
keymap("n", "tt", "<C-]>", { desc = "Jump to tag definition" })

-- Buffer Management
keymap("n", "<leader>q", ":<C-u>bdelete!<CR>", { desc = "Close current buffer" })

-- Git Integration
keymap("n", "<leader>v", ":.GBrowse!<CR>", { desc = "Copy Git link to current line" })
keymap("x", "<leader>v", ":GBrowse!<CR>", { desc = "Copy Git link for selection" })

-- Increment and Decrement Numbers
keymap("n", "<leader>=", "<C-a>", { desc = "Increment number" })
keymap("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Exit Insert Mode Quickly
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- Window Splitting
keymap("n", "<C-w>\\", ":vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<C-w>-", ":split<CR>", { desc = "Horizontal split" })

-- Command Aliases
command("Q", "q", {})
command("W", "w", {})
command("WQ", "wq", {})
command("Wq", "wq", {})
command("QA", "qa", {})
command("Qa", "qa", {})

-- Save and Source
keymap("n", "<leader><CR>", ":w<CR>:source %<CR>", { desc = "Save and source this file" })
