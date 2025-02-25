-------------------------------------------------------------------------------
-- autocommands
--
-- see https://neovim.io/doc/user/autocmd.html
-------------------------------------------------------------------------------

local mnishiguchi_augroup = vim.api.nvim_create_augroup("mnishiguchi_augroup", {})

-- Dynamically detect filetypes based on filename patterns
local filetype_patterns = {
  ["*.livemd"] = "markdown",
  ["Gemfile"] = "ruby",
  ["Rakefile"] = "ruby",
  ["Vagrantfile"] = "ruby",
  ["Thorfile"] = "ruby",
  ["Guardfile"] = "ruby",
  ["config.ru"] = "ruby",
  ["*.rake"] = "ruby",
  ["*.jbuilder"] = "ruby",
}

for pattern, filetype in pairs(filetype_patterns) do
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = mnishiguchi_augroup,
    pattern = pattern,
    callback = function()
      vim.opt_local.filetype = filetype
    end,
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
      vim.opt.foldmethod = "manual" -- Disable folding to avoid parsing
      vim.notify("Large file detected. Performance settings applied.", vim.log.levels.WARN)
    end
  end,
})
