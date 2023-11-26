-- https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings-set
local keymap = vim.keymap.set
-- https://neovim.io/doc/user/lua-guide.html#lua-guide-commands
local command = vim.api.nvim_create_user_command

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
keymap({ "n", "v" }, "<Space>", "<Nop>", { desc = "no op" })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- show the file explore
keymap("n", "<leader>e", vim.cmd.Explore, { desc = ":Explore" })

-- move the highlighted lines around in visual mode
keymap("v", "J", ":move '>+1<CR>gv=gv", { desc = "move highlighted lines down" })
keymap("v", "K", ":move '<-2<CR>gv=gv", { desc = "move highlighted lines up" })
keymap("v", "H", "<gv", { desc = "move highlighted lines left" })
keymap("v", "L", ">gv", { desc = "move highlighted lines right" })

-- Stay in indent mode
keymap("v", "<", "<gv", { desc = "move highlighted lines left" })
keymap("v", ">", ">gv", { desc = "move highlighted lines right" })

-- keep the cursor in the same place while joining lines
keymap("n", "J", "mzJ`z")

-- keep the cursor centered while moving up and down
keymap("n", "j", "jzz")
keymap("n", "k", "kzz")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "<Up>", "<Up>zz")
keymap("n", "<Down>", "<Down>zz")

-- keep the cursor centered while searching
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- disable <leader>p to avoid unexpected pasting
keymap({ "n", "v" }, "<leader>p", "<Nop>", { desc = "no op" })

-- put the yanked text onto the visually selected text
keymap("v", "p", '"_dP', { desc = "[p]aste the yanked onto the visually selected" })

-- delete without overwriting the unnamed register
keymap("n", "<leader>d", '"_d', { desc = "[d]elete without writing unnamed register" })
keymap("v", "<leader>d", '"_d', { desc = "[d]elete without writing unnamed register" })
keymap("n", "x", '"_x', { desc = "delete without writing unnamed register" })

-- find and replace what the cursor is currently is on
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/cgI<Left><Left><Left><Left>]], {
	desc = "[s]ubstitute what cursor is currently is on",
})

-- make tags for tag-jumping
keymap("n", "<leader>ct", ":!ctags -R .<CR>", { desc = "make [ct]ags" })
keymap("n", "tt", "<C-]>")

-- close buffers
keymap("n", "<leader>q", ":<C-u>bdelete!<CR>", { desc = "[q]uit current buffer" })

-- Copy the link to the line of a Git repository to the clipboard
keymap("n", "<leader>v", ":.GBrowse!<CR>")
keymap("x", "<leader>v", ":GBrowse!<CR>")

-- bind :Q to :q
command("Q", "q", {})
command("W", "w", {})
command("WQ", "wq", {})
command("Wq", "wq", {})
command("QA", "qa", {})
command("Qa", "qa", {})

-- increment/decrement numbers
keymap("n", "<leader>+", "<C-a>") -- increment
keymap("n", "<leader>_", "<C-x>") -- decrement

-- tabs
keymap("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap("n", "<leader>t]", ":tabn<CR>") -- go to next tab
keymap("n", "<leader>t[", ":tabp<CR>") -- go to previous tab

-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>")
keymap("i", "kj", "<ESC>")
