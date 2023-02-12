-------------------------------------------------------------------------------
-- options
-- see https://neovim.io/doc/user/options.html
-------------------------------------------------------------------------------

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- cursor line
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- indent
vim.opt.autoindent = true
vim.opt.smartindent = true

-- diffs
vim.opt.diffopt = "filler,vertical" -- side by side

-- command completion
vim.opt.path:append("**")
vim.opt.wildmenu = true
vim.opt.wildmode = "full"

-- word wrap
vim.opt.wrap = false              -- do not automatically wrap on load
vim.opt.formatoptions:remove("t") -- do not automatically wrap text when typing

-- search highlight
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- others
vim.opt.termguicolors = true -- enable highlight groups
vim.opt.isfname:append("@-@") -- all alphas
