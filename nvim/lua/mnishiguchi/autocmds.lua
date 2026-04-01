-------------------------------------------------------------------------------
-- autocommands
--
-- see https://neovim.io/doc/user/autocmd.html
-------------------------------------------------------------------------------

local mnishiguchi_augroup = vim.api.nvim_create_augroup("mnishiguchi_augroup", {
  clear = true,
})

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
    callback = function(args)
      vim.bo[args.buf].filetype = filetype
    end,
  })
end

-- Large file optimization (prevent slowdowns)
vim.api.nvim_create_autocmd("BufReadPre", {
  group = mnishiguchi_augroup,
  pattern = "*",
  callback = function(args)
    local max_size = 1024 * 1024 -- 1 MB
    local file_path = vim.api.nvim_buf_get_name(args.buf)
    local stat = file_path ~= "" and vim.uv.fs_stat(file_path) or nil

    if stat and stat.size > max_size then
      vim.bo[args.buf].swapfile = false -- Disable swapfile
      vim.bo[args.buf].undofile = false -- Disable undo history
      vim.b[args.buf].large_file = true
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = mnishiguchi_augroup,
  pattern = "*",
  callback = function(args)
    if vim.b[args.buf].large_file then
      vim.opt_local.syntax = "off"        -- Disable syntax highlighting
      vim.opt_local.foldmethod = "manual" -- Disable folding to avoid parsing
      vim.notify_once("Large file detected. Performance settings applied.", vim.log.levels.WARN)
    end
  end,
})

-- Format Makefiles on save (Conform runs synchronously on BufWritePre)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = mnishiguchi_augroup,
  pattern = { "Makefile", "makefile", "GNUmakefile", "*.mk" },
  callback = function(args)
    local ok, conform = pcall(require, "conform")
    if not ok then return end
    if vim.bo[args.buf].filetype ~= "make" then return end

    conform.format({
      bufnr = args.buf,
      lsp_fallback = true,
      timeout_ms = 2000,
    })
  end,
})
