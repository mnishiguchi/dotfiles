-------------------------------------------------------------------------------
-- autocommands
--
-- see https://neovim.io/doc/user/autocmd.html
-------------------------------------------------------------------------------

local mnishiguchi_augroup = vim.api.nvim_create_augroup("mnishiguchi_augroup", {})

-- Strip trailing whitespace on write
vim.api.nvim_create_autocmd("BufWritePre", {
  group = mnishiguchi_augroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = mnishiguchi_augroup,
  pattern = "*",
  callback = function()
    -- See `:help vim.highlight.on_yank()`
    vim.highlight.on_yank()
  end,
})

-- Open quick fix window on grep
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = mnishiguchi_augroup,
  pattern = "*grep*",
  command = [[cwindow]],
})

-- Treat Rofi files as SCSS
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = mnishiguchi_augroup,
  pattern = "*.rasi",
  command = [[set filetype=scss]],
})

-- Handle Markdown files without .md
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = mnishiguchi_augroup,
  pattern = "*.livemd",
  command = [[set filetype=markdown]],
})

-- Handle Ruby files without .rb
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = mnishiguchi_augroup,
  pattern = "Gemfile,Rakefile,Vagrantfile,Thorfile,Guardfile,config.ru,*.rake,*.jbuilder",
  command = [[set filetype=ruby]],
})

-- Large file optimization (prevent slowdowns)
vim.api.nvim_create_autocmd("BufReadPre", {
  group = mnishiguchi_augroup,
  pattern = "*",
  callback = function()
    local max_size = 1024 * 1024    -- 1 MB
    if vim.fn.getfsize(vim.fn.expand("%")) > max_size then
      vim.opt.syntax = "off"        -- Disable syntax highlighting
      vim.opt.swapfile = false      -- Disable swapfile
      vim.opt.undofile = false      -- Disable undo history
      vim.opt.bufhidden = "unload"  -- Unload the buffer when hidden
      vim.opt.foldmethod = "manual" -- Disable folding to avoid parsing
      vim.notify("Large file detected. Performance settings applied.", vim.log.levels.WARN)
    end
  end,
})
