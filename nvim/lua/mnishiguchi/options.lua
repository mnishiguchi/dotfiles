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
vim.opt.colorcolumn = '80'
vim.opt.scrolloff = 8

-- tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- indent
vim.opt.autoindent = true
vim.opt.smartindent = true

-- diffs
vim.opt.diffopt = 'filler,vertical' -- side by side

-- command completion
vim.opt.path:append('**')
vim.opt.wildmenu = true
vim.opt.wildmode = 'full'

-- word wrap
vim.opt.wrap = false              -- do not automatically wrap on load
vim.opt.formatoptions:remove('t') -- do not automatically wrap text when typing

-- search highlight
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true -- enable highlight groups

-- Support all alphas in filenames
vim.opt.isfname:append('@-@')
