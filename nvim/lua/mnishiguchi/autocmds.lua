-------------------------------------------------------------------------------
-- autocommands
--
-- see https://neovim.io/doc/user/autocmd.html
-------------------------------------------------------------------------------

local mnishiguchi_augroup = vim.api.nvim_create_augroup("mnishiguchi_augroup", {
  clear = true,
})

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
