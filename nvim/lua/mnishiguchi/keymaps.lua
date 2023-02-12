-------------------------------------------------------------------------------
-- key mapping
-- see https://neovim.io/doc/user/map.html
-------------------------------------------------------------------------------

-- use space as mapleader
vim.g.mapleader = " "

-- edit vimrc quickly
vim.keymap.set("n", "<leader>.", ":<C-u>find $MYVIMRC<CR>:<C-u>Explore<CR>")
vim.keymap.set("n", "<leader>s.", ":<C-u>source $MYVIMRC<CR>")

-- show the file explore
vim.keymap.set("n", "<leader>pv", vim.cmd.Explore)

-- move the highlighted line up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep the cursor in the same place while joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- keep the cursor centered while moving up and down
vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep the cursor centered while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- put the yanked text onto the visually selected text
vim.keymap.set("x", "<leader>p", "\"_dP")

-- yank to the system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- delete without overwriting the unnamed register
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- find and replace what the cursor is currently is on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make executable the file currently being editied
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- make tags for tag-jumping
vim.keymap.set("n", "<leader>ct", ":!ctags -R .<CR>")
vim.keymap.set("n", "t", "<Nop>")
vim.keymap.set("n", "tt", "<C-]>")

-- check marks and registers easily
vim.keymap.set("n", "<leader>m", ":<C-u>marks<CR>")
vim.keymap.set("n", "<leader>r", ":<C-u>registers<CR>")
vim.keymap.set("n", "<leader>t", ":<C-u>tags<CR>")

-- bind :Q to :q
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("QA", "qall", {})
vim.api.nvim_create_user_command("Qa", "qall", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("E", "e", {})
