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

-- Handle Markdown files witout .md
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = mnishiguchi_augroup,
  pattern = "*.livemd",
  command = [[set filetype=markdown]],
})

-- Handle Ruby files without .rb
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = mnishiguchi_augroup,
  pattern = "Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Guardfile,config.ru,*.rake",
  command = [[set filetype=ruby]],
})

-- Handle HTML files without .html
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = mnishiguchi_augroup,
  pattern = "*.erb",
  command = [[set filetype=html]],
})

