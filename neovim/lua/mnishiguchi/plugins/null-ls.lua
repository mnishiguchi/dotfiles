-- Inject LSP diagnostics, code actions, and more
return {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
    local lsp_formatting = function()
      vim.lsp.buf.format({
        async = false,
        -- Choosing a client for formatting
        -- filter = function(client)
        --   return client.name == "null-ls"
        -- end,
      })
    end

    -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    -- local on_attach = function(client, bufnr)
    --   -- Formatting on save
    --   -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
    --   if client.supports_method("textDocument/formatting") then
    --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

    --     vim.api.nvim_create_autocmd("BufWritePre", {
    --       group = augroup,
    --       buffer = bufnr,
    --       callback = lsp_formatting,
    --     })
    --   end
    -- end

    null_ls.setup({
      debug = false,
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      sources = {
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.mix,
        null_ls.builtins.formatting.stylua,
      },
      -- on_attach = on_attach,
    })

    -- Define commands
    vim.api.nvim_create_user_command("Format", lsp_formatting, {})

    -- vim.api.nvim_create_user_command("FormatDisableOnSave", function()
    --   vim.api.nvim_clear_autocmds({ group = augroup })
    -- end, {})

    -- Define keymapping
    vim.keymap.set("n", "<leader>lf", ":Format<CR>", { desc = "[l]sp [f]ormat" })
    vim.keymap.set("n", "<leader>ln", ":NullLsInfo<CR>", { desc = "[l]sp [n]ull-ls info" })
    vim.keymap.set("n", "<leader>li", ":LspInfo<CR>", { desc = "[l]sp [i]nfo" })
  end,
  dependencies = { "nvim-lua/plenary.nvim" },
}
