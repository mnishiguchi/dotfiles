-- https://github.com/mhartington/formatter.nvim
return {
  "mhartington/formatter.nvim",
  config = function()
    -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
    require("formatter").setup {
      -- Enable or disable logging
      logging = true,
      -- Set the log level
      log_level = vim.log.levels.WARN,
      -- All formatter configurations are opt-in
      -- For default formatters, see: https://github.com/mhartington/formatter.nvim/tree/master/lua/formatter
      filetype = {
        -- will be executed in order
        blade = function()
          return {
            exe = "blade-formatter",
            args = {
              "--stdin",
              "--no-multiple-empty-lines",
              "--wrap-attributes=force-expand-multiline",
            },
            stdin = true
          }
        end,
        css = require("formatter.defaults").prettierd,
        dart = require("formatter.filetypes").dart.dartformat,
        eruby = require("formatter.defaults").htmlbeautifier,
        elixir = require("formatter.defaults").mixformat,
        graphql = require("formatter.defaults").prettierd,
        html = require("formatter.defaults").htmlbeautifier,
        javascript = require("formatter.defaults").prettierd,
        javascriptreact = require("formatter.defaults").prettierd,
        json = require("formatter.defaults").prettierd,
        markdown = require("formatter.defaults").prettierd,
        php = require("formatter.filetypes").php.pint,
        ruby = require("formatter.defaults").rubocop,
        sh = require("formatter.defaults").shfmt,
        toml = require("formatter.defaults").taplo,
        typescript = require("formatter.defaults").prettierd,
        typescriptreact = require("formatter.defaults").prettierd,
        xml = require("formatter.defaults").xmllint,
        yaml = require("formatter.defaults").prettierd,

        -- Use the special "*" filetype for defining formatter configurations on any filetype
        ["*"] = {
          -- "formatter.filetypes.any" defines default configurations for any filetype
          require("formatter.filetypes.any").remove_trailing_whitespace,
        }
      }
    }
  end,
}
