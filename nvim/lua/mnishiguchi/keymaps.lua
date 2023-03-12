-------------------------------------------------------------------------------
-- key mapping
-- see https://neovim.io/doc/user/map.html
-------------------------------------------------------------------------------

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { desc = 'no op' })

-- edit vimrc quickly
vim.keymap.set("n", "<leader>.", ":<C-u>find $MYVIMRC<CR>:<C-u>Explore<CR>", { desc = 'open MYVIMRC' })
vim.keymap.set("n", "<leader>s.", ":<C-u>source $MYVIMRC<CR>", { desc = '[s]ource (reload) MYVIMRC' })

-- show the file explore
vim.keymap.set("n", "<leader>pv", vim.cmd.Explore, { desc = '[p]roject: [v]iew files' })

-- move the highlighted line up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'move the highlighted line(s) down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'move the highlighted line(s) up' })


-- keep the cursor in the same place while joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- keep the cursor centered while moving up and down
vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<Up>", "<Up>zz")
vim.keymap.set("n", "<Down>", "<Down>zz")

-- keep the cursor centered while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- disable <leader>p in normal mode to avoid unexpected pasting
vim.keymap.set("n", "<leader>p", "<Nop>", { desc = 'no op' })

-- put the yanked text onto the visually selected text
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = '[p]aste the yanked onto the visually selected' })

-- delete without overwriting the unnamed register
vim.keymap.set("n", "<leader>d", "\"_d", { desc = '[d]elete without overwriting the unnamed register' })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = '[d]elete without overwriting the unnamed register' })

-- find and replace what the cursor is currently is on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/cgI<Left><Left><Left><Left>]], {
  desc = '[s]ubstitute what the cursor is currently is on'
})

-- make executable the file currently being editied
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = 'make the file e[x]ecutable' })

-- make tags for tag-jumping
vim.keymap.set("n", "<leader>ct", ":!ctags -R .<CR>", { desc = 'make [ct]ags' })
vim.keymap.set("n", "tt", "<C-]>")

-- close buffers
vim.keymap.set("n", "<leader>q", ":<C-u>bdelete!<CR>", { desc = '[q]uit the current buffer' })

-- bind :Q to :q
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("QA", "qall", {})
vim.api.nvim_create_user_command("Qa", "qall", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("E", "e", {})
