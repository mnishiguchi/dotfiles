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
vim.opt.wrap = false              -- no automatic wrap on load
vim.opt.formatoptions:remove("t") -- no automatic wrap text when typing

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.winbar = "%=%m %f"
vim.g.netrw_banner = 0

-- clipboard
vim.opt.clipboard = "unnamedplus" -- sync clipboard between OS and Neovim

-- backspace
vim.opt.backspace = "indent,eol,start" -- make backspace work like other programs

-- diffs
vim.opt.diffopt = "filler,vertical" -- side by side diffs

-- command completion
vim.opt.path:append("**")
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"

-- insert-mode completion
vim.opt.completeopt = "menuone,noselect"

-- mouse mode
vim.opt.mouse = "a"

-- undo history
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- etc
vim.opt.isfname:append("@-@") -- support all alphas in filenames
vim.opt.iskeyword:append("-") -- make "-" part of word

-- Performance and safe defaults
vim.opt.swapfile = false    -- Disable swap file to avoid potential corruption
vim.opt.backup = false      -- Disable backup files
vim.opt.writebackup = false -- Disable write backups
vim.opt.hidden = true       -- Allow hidden buffers
vim.opt.updatetime = 300    -- Faster completion and linting updates
vim.opt.timeoutlen = 500    -- Reduce timeout for key sequences
vim.opt.lazyredraw = true   -- Improve performance for macros and large files
vim.opt.synmaxcol = 200     -- Limit syntax highlighting for performance
vim.opt.redrawtime = 10000  -- Allow more time for syntax highlighting in large files
vim.opt.history = 1000      -- Increase command history size
vim.opt.autoread = true     -- Automatically reload files changed outside of Neovim
