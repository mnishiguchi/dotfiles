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

-- Set up formatting
local setup_formatting = function()
  local shortcut = "<leader>lf"

  -- Use external executable for formatting by default
  vim.keymap.set("n", shortcut, vim.cmd.Neoformat, {})

  -- Define a custom command that formats current buffer
  local lsp_format = function()
    -- Some language server implement a formatter but we want to use a different one
    -- See https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
    local ignored_language_servers = {
      "tsserver",
    }

    local should_format = function(client)
      for _, ignored_language_server in ipairs(ignored_language_servers) do
        if ignored_language_server == client.name then
          vim.print("skipped requesting " .. client.name .. " for formatting")
          return false
        end
      end

      vim.print("requested " .. client.name .. " for formatting")
      return true
    end

    vim.lsp.buf.format({ filter = should_format })
  end

  -- Define a custom command that formats current buffer though the LSP client
  vim.api.nvim_create_user_command("Format", lsp_format, {})

  -- Set keymap for formatting according to the attached language server
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      -- Use the attached language server for formatting if possible
      if client.server_capabilities.documentFormattingProvider then
        vim.keymap.set("n", shortcut, vim.cmd.Format, { buffer = event.buf })
      end
    end,
  })
end

setup_formatting()
