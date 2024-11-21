-- A starting point to setup some LSP related features
-- https://lsp-zero.netlify.app/docs/guide/lazy-loading-with-lazy-nvim.html
return {
  {
    -- https://github.com/VonHeikemen/lsp-zero.nvim
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    lazy = true,
    config = false,
  },

  -- Autocompletion
  -- https://github.com/hrsh7th/nvim-cmp
  {
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
      local cmp_action = require('lsp-zero').cmp_action()

      cmp.setup({
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'luasnip', keyword_length = 2 },
          { name = 'buffer',  keyword_length = 5 },
        }),
        mapping = cmp.mapping.preset.insert({
          -- Regular tab complete
          -- https://lsp-zero.netlify.app/docs/autocomplete.html#regular-tab-complete
          ['<Tab>'] = cmp_action.tab_complete(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
          -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        formatting = lsp_zero.cmp_format({ details = true }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end
  },

  -- LSP
  -- https://github.com/neovim/nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      -- this is where you enable features that only work
      -- if there is a language server active in the file
      local lsp_attach = function(client, bufnr)
        local opts = { buffer = bufnr }

        -- create a keymap gq to format the current buffer using all active servers with formatting capabilities
        vim.keymap.set({ 'n', 'x' }, '<space>gq', function()
          -- Use the attached language server for formatting if possible
          if client.server_capabilities.documentFormattingProvider then
            vim.print("using " .. client.name .. " for formatting")
            vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
          else
            vim.print("using formatter.nvim for formatting")
            vim.cmd.Format()
          end
        end, opts)

        lsp_zero.default_keymaps({
          buffer = bufnr,
          -- force lsp-zero's bindings by adding preserve_mappings = false
          preserve_mappings = false
        })
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      })

      lsp_zero.ui({
        sign_text = {
          error = '✘',
          warn = '▲',
          hint = '⚑',
          info = '»',
        },
      })

      require('mason').setup({
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
          }
        }
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
          'ts_ls',
          'lua_ls',
          'marksman',
          'pyright',
          'rust_analyzer',
          'rubocop',
          'ruby_lsp',
          'sqlls',
          'taplo',
          'yamlls',
          'zls',
        },
        -- For default configs nvim-lspconfig defines, see:
        -- https://github.com/neovim/nvim-lspconfig/tree/28b205ebe73a18f401e040585106f9bafd8ff21f/lua/lspconfig/configs
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
          lua_ls = function()
            -- Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
          cssls = function()
            require('lspconfig').cssls.setup({
              settings = {
                -- to suppress warning: "Unknown rule @tailwind @apply"
                css = { lint = { unknownAtRules = 'ignore' } }
              },
            })
          end,
          emmet_language_server = function()
            require('lspconfig').emmet_language_server.setup({
              filetypes = {
                "blade",
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
        }
      })
    end
  },

  -- Snippet engine
  -- https://github.com/L3MON4D3/LuaSnip
  {
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
