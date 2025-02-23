-- A starting point to setup some LSP related features
-- https://lsp-zero.netlify.app/docs/guide/lazy-loading-with-lazy-nvim.html
return {
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
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities() -- Enable LSP capabilities for completion

      require('mason').setup({})

      -- https://lsp-zero.netlify.app/docs/language-server-configuration.html
      require('mason-lspconfig').setup({
        -- A list of servers to automatically install if they're not already installed.
        -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
        ensure_installed = {
          'bashls',
          'cssls',
          'elixirls',
          'emmet_language_server', -- https://github.com/olrtg/emmet-language-server
          'gopls',
          'html',
          'jsonls',
          'lua_ls',
          'rust_analyzer',
          'rubocop',
          'ruby_lsp',
          'yamlls',
        },
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,
        }
      })

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } }, -- Prevent warnings about 'vim' being undefined
          },
        },
      })

      lspconfig.cssls.setup({
        settings = {
          css = { lint = { unknownAtRules = 'ignore' } }, -- Suppress warnings for unknown CSS rules
        },
      })

      lspconfig.emmet_language_server.setup({
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
        init_options = {
          includeLanguages = {
            html = "html",
            javascript = "javascript",
            javascriptreact = "html",
            typescript = "typescript",
            typescriptreact = "html",
            vue = "html",
            ruby = "html",
            eelixir = "html",
            heex = "html",
            markdown = "html",
            css = "css",
            scss = "scss",
            sass = "sass",
            less = "less",
          },
        },
      })

      lspconfig.gopls.setup({
        settings = {
          gopls = {
            usePlaceholders = true, -- Enables placeholders in completion snippets
            completeUnimported = true, -- Automatically adds imports
            analyses = {
              unusedparams = true, -- Warns about unused parameters
            },
            staticcheck = true,  -- Enables additional static analysis
          },
        },
      })

      lspconfig.ruby_lsp.setup({
        init_options = {
          formatter = 'standard',
          linters = { 'standard' },
        },
      })

      -- Runs when an LSP server attaches to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local id = vim.tbl_get(event, 'data', 'client_id')
          local client = id and vim.lsp.get_client_by_id(id)
          if client == nil then
            return
          end

          local opts = { buffer = event.buf }
          -- Navigation
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

          -- Documentation & Signature
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

          -- Diagnostic navigation
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

          -- Format buffer with LSP
          vim.keymap.set({ 'n', 'x' }, '<space>gq', function()
            if client.server_capabilities.documentFormattingProvider then
              vim.print("Using " .. client.name .. " for formatting")
              vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
            else
              vim.print("Using formatter.nvim for formatting")
              vim.cmd.Format()
            end
          end, opts)
        end
      })
    end,
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
      local cmp = require('cmp')

      cmp.setup({
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'luasnip', keyword_length = 2 },
          { name = 'buffer',  keyword_length = 5 },
        }),
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item({ behavior = 'select' }),   -- Navigate forward in completion menu
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }), -- Navigate backward in completion menu
          ['<CR>'] = cmp.mapping.confirm({ select = false }),                  -- Confirm selection
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end
  },

  -- Snippet engine
  -- https://github.com/L3MON4D3/LuaSnip
  {
    'L3MON4D3/LuaSnip',
    version = "v2.*",
    dependencies = {
      -- bridges LuaSnip with nvim-cmp, making snippets available in completion suggestions
      "saadparwaiz1/cmp_luasnip",
      -- provides predefined snippets for many languages
      'rafamadriz/friendly-snippets',
    },
    config = function(_, opts)
      if opts then require('luasnip').config.setup(opts) end

      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  }
}
