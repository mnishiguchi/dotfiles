-------------------------------------------------------------------------------
-- key mapping
-- see https://neovim.io/doc/user/map.html
-------------------------------------------------------------------------------

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { desc = "no op" })

-- edit vimrc quickly
vim.keymap.set("n", "<leader>.", ":<C-u>find $MYVIMRC<CR>:<C-u>Explore<CR>", { desc = "open MYVIMRC" })
vim.keymap.set("n", "<leader>s.", ":<C-u>source $MYVIMRC<CR>", { desc = "[s]ource (reload) MYVIMRC" })

-- show the file explore
vim.keymap.set("n", "<leader>e", vim.cmd.Explore)
vim.keymap.set("n", "<leader>pv", vim.cmd.Explore, { desc = "[p]roject: [v]iew files" })

-- move the highlighted line up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move the highlighted line(s) down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move the highlighted line(s) up" })

-- keep the cursor in the same place while joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- keep the cursor centered while moving up and down
vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<Up>", "<Up>zz")
vim.keymap.set("n", "<Down>", "<Down>zz")

-- keep the cursor centered while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- disable <leader>p in normal mode to avoid unexpected pasting
vim.keymap.set("n", "<leader>p", "<Nop>", { desc = "no op" })

-- put the yanked text onto the visually selected text
vim.keymap.set("v", "p", '"_dP', { desc = "[p]aste the yanked onto the visually selected" })

-- delete without overwriting the unnamed register
vim.keymap.set("n", "<leader>d", '"_d', { desc = "[d]elete without overwriting the unnamed register" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "[d]elete without overwriting the unnamed register" })
vim.keymap.set("n", "x", '"_x', { desc = "delete a character without overwriting the unnamed register" })

-- find and replace what the cursor is currently is on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/cgI<Left><Left><Left><Left>]], {
	desc = "[s]ubstitute what the cursor is currently is on",
})

-- make tags for tag-jumping
vim.keymap.set("n", "<leader>ct", ":!ctags -R .<CR>", { desc = "make [ct]ags" })
vim.keymap.set("n", "tt", "<C-]>")

-- close buffers
vim.keymap.set("n", "<leader>q", ":<C-u>bdelete!<CR>", { desc = "[q]uit the current buffer" })

-- bind :Q to :q
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Wq", "wq", {})

-- increment/decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>") -- increment
vim.keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

vim.keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab
