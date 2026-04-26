-- lines and columns
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 8

-- tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- indent
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- format
vim.opt.wrap = false -- no automatic wrap on load
vim.opt.formatoptions:remove("t") -- no automatic wrap text when typing

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.winborder = "rounded"
vim.opt.winbar = "%=%m %f"
vim.g.netrw_banner = 0

-- clipboard
vim.opt.clipboard = "unnamedplus" -- sync clipboard between OS and Neovim

-- diffs
vim.opt.diffopt:append("vertical") -- side-by-side diffs

-- command completion
vim.opt.wildmode = "longest:full,full"

-- mouse mode
vim.opt.mouse = "a"

-- undo history
vim.opt.undofile = true

-- word and filename behavior
vim.opt.isfname:append("@-@") -- support @ in filenames
vim.opt.iskeyword:append("-") -- make "-" part of word

-- responsiveness
vim.opt.updatetime = 300 -- faster CursorHold events
vim.opt.timeoutlen = 500 -- shorter timeout for key sequences
vim.opt.autoread = true -- automatically reload files changed outside of Neovim
