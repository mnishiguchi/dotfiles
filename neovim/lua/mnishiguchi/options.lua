-------------------------------------------------------------------------------
-- options
-- see https://neovim.io/doc/user/options.html
-------------------------------------------------------------------------------

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- indent
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- line wrapping
vim.opt.wrap = false              -- no automatic wrap on load
vim.opt.formatoptions:remove('t') -- no automatic wrap text when typing

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- appearance
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.colorcolumn = '80'
vim.opt.scrolloff = 8

-- clipboard
vim.opt.clipboard = 'unnamedplus' -- sync clipboard between OS and Neovim

-- backspace
vim.optbackspace = 'intent,eol,start'

-- diffs
vim.opt.diffopt = 'filler,vertical' -- side by side

-- command completion
vim.opt.path:append('**')
vim.opt.wildmenu = true
vim.opt.wildmode = 'full'

-- insert-mode completion
vim.opt.completeopt = 'menuone,noselect'

-- mouse mode
vim.opt.mouse = 'a'

-- undo history
vim.opt.undofile = true

-- etc
vim.opt.isfname:append('@-@') -- support all alphas in filenames
vim.opt.iskeyword:append("-") -- make "-" part of word
