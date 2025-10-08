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
    local util = require("conform.util")

    local prettier_config_file_names = {
      -- https://prettier.io/docs/en/configuration.html
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.yml",
      ".prettierrc.yaml",
      ".prettierrc.json5",
      ".prettierrc.js",
      ".prettierrc.cjs",
      ".prettierrc.mjs",
      ".prettierrc.toml",
      "prettier.config.js",
      "prettier.config.cjs",
      "prettier.config.mjs",
    }

    require("conform").setup({
      formatters = {
        ["clang-format"] = {
          command = "clang-format",
          args = { "--assume-filename", "$FILENAME" },
          stdin = true,
        },
        rbprettier = {
          command   = "bundle",
          args      = { "exec", "rbprettier", "--stdin-filepath", "$FILENAME" },
          stdin     = true,
          condition = function()
            return util.root_file(prettier_config_file_names) ~= nil
          end,
        },
      },
      formatters_by_ft = {
        c               = { "clang-format" },
        cpp             = { "clang-format" },
        blade           = { "blade-formatter" },
        css             = { "prettierd" },
        dart            = { "dart_format" },
        elixir          = { "mixformat" },
        eruby           = { "htmlbeautifier" },
        graphql         = { "prettierd" },
        html            = { "htmlbeautifier" },
        javascript      = { "prettierd" },
        javascriptreact = { "prettierd" },
        json            = { "prettierd" },
        markdown        = { "prettierd" },
        php             = { "pint" },
        ruby            = { "rbprettier", "rubocop" },
        sh              = { "shfmt" },
        toml            = { "taplo" },
        typescript      = { "prettierd" },
        typescriptreact = { "prettierd" },
        xml             = { "xmllint" },
        yaml            = { "prettierd" },
        ["*"]           = { "trim_whitespace" },
      },
    })
  end,
}
