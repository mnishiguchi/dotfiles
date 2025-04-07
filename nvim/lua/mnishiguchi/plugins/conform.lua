return {
  "stevearc/conform.nvim",
  init = function()
    vim.api.nvim_create_user_command("Format", function()
      require("conform").format({ async = true, lsp_fallback = true })
    end, { desc = "Format buffer using Conform" })

    vim.api.nvim_create_user_command("FormatWrite", function()
      require("conform").format({ async = true, lsp_fallback = true })
      vim.cmd.write()
    end, { desc = "Format and write buffer using Conform" })
  end,
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        blade = { "blade-formatter" },
        css = { "prettierd" },
        graphql = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        json = { "prettierd" },
        markdown = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        yaml = { "prettierd" },
        dart = { "dart_format" },
        eruby = { "htmlbeautifier" },
        html = { "htmlbeautifier" },
        elixir = { "mixformat" },
        php = { "pint" },
        ruby = { "rubocop" },
        sh = { "shfmt" },
        toml = { "taplo" },
        xml = { "xmllint" },
        ["*"] = { "trim_whitespace" },
      },
    })
  end,
}
