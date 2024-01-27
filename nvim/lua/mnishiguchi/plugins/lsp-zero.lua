-- A starting point to setup some LSP related features
-- https://github.com/VonHeikemen/lsp-zero.nvim/tree/v3.x
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/lazy-loading-with-lazy-nvim.md
return {
  {
    -- https://github.com/VonHeikemen/lsp-zero.nvim
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    -- https://github.com/williamboman/mason.nvim
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
          }
        }
      })
    end,
  },
  {
    -- LSP
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      --- if you want to know more about lsp-zero and mason.nvim
      --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false -- force lsp-zero's bindings
        })
      end)

      lsp_zero.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })

      require('mason-lspconfig').setup({
        -- language servers you want to be installed automatically
        -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
        ensure_installed = {
          'bashls',
          'cssls',
          'dockerls',
          'eslint',
          'elixirls',
          'emmet_language_server', -- https://github.com/olrtg/emmet-language-server
          'html',
          'jsonls',
          'tsserver',
          'lua_ls',
          'marksman',
          'pyright',
          'ruby_ls',
          'sqlls',
          'taplo',
          'yamlls',
          'zls',
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            -- Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
          emmet_language_server = function()
            require('lspconfig').emmet_language_server.setup({
              filetypes = {
                "css",
                "eelixir",
                "elixir",
                "eruby",
                "heex",
                "html",
                "javascript",
                "javascriptreact",
                "less",
                "markdown",
                "pug",
                "sass",
                "scss",
                "typescriptreact"
              },
              -- See https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration
              init_options = {
                excludeLanguages = {},
              },
            })
          end,
          tsserver = lsp_zero.noop,
        }
      })
    end
  },
  {
    -- Autocompletion
    -- https://github.com/hrsh7th/nvim-cmp
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')

      cmp.setup({
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'luasnip', keyword_length = 2 },
          { name = 'buffer',  keyword_length = 5 },
        }, {
        }),
      })
    end
  },
  {
    -- Snippet engine
    -- https://github.com/L3MON4D3/LuaSnip
    'L3MON4D3/LuaSnip',
    version = "v2.*",
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function(_, opts)
      if opts then require('luasnip').config.setup(opts) end

      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  }
}
