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
  callback = vim.highlight.on_yank,
})

-- Open quick fix window on grep
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = mnishiguchi_augroup,
  pattern = "*grep*",
  command = "cwindow",
})

-- Dynamically detect filetypes based on filename patterns
local filetype_patterns = {
  ["*.rasi"] = "js",
  ["*.livemd"] = "markdown",
  ["Gemfile,Rakefile,Vagrantfile,Thorfile,Guardfile,config.ru,*.rake,*.jbuilder"] = "ruby",
}

for pattern, filetype in pairs(filetype_patterns) do
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = mnishiguchi_augroup,
    pattern = pattern,
    command = "set filetype=" .. filetype,
  })
end

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
