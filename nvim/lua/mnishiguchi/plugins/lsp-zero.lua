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
      local capabilities = require('cmp_nvim_lsp').default_capabilities() -- Enable nvim-cmp completion support

      -- Servers that are enabled using Neovim 0.11's native `vim.lsp.enable()` mechanism.
      -- These should *not* be configured again via mason-lspconfig handlers.
      local natively_enabled_servers = {
        'bashls',
        'cssls',
        'gopls',
        'html',
        'jsonls',
        'rubocop',
        'ruby_lsp',
        'rust_analyzer',
        'yamlls',
      }

      local function list_to_lookup(list)
        local t = {}
        for _, v in ipairs(list) do t[v] = true end
        return t
      end

      local native_enabled_lookup = list_to_lookup(natively_enabled_servers)

      -- Load and setup a language server with optional custom config from lsp/<server_name>.lua
      local function setup_lsp(server_name)
        local ok, opts = pcall(require, "lsp." .. server_name)
        if not ok then
          opts = {} -- fallback to empty config
        end
        opts.capabilities = capabilities
        lspconfig[server_name].setup(opts)
      end

      require('mason').setup({})

      -- https://lsp-zero.netlify.app/docs/language-server-configuration.html
      require('mason-lspconfig').setup({
        -- A list of servers to automatically install if they're not already installed.
        -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
        ensure_installed = natively_enabled_servers,
        handlers = {
          function(server_name)
            if native_enabled_lookup[server_name] then return end
            setup_lsp(server_name)
          end
        }
      })

      -- Enable LSP servers using Neovim 0.11's native mechanism
      for _, server in ipairs(natively_enabled_servers) do
        setup_lsp(server)      -- apply your custom config
        vim.lsp.enable(server) -- register with Neovim's LSP manager
      end

      -- Runs when an LSP server attaches to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local client = vim.lsp.get_clients({ id = event.data.client_id })[1]
          if not client then return end

          vim.notify('Attached LSP: ' .. client.name, vim.log.levels.INFO)

          local opts = { buffer = event.buf }
          local fmt_opts = { async = false, timeout_ms = 3000 }

          local function lsp_buf_format_with_fallback(client)
            if client.server_capabilities.documentFormattingProvider then
              vim.notify('Using ' .. client.name .. ' for formatting', vim.log.levels.INFO)
              vim.lsp.buf.format(fmt_opts)
            else
              vim.notify('Using formatter.nvim for formatting', vim.log.levels.INFO)
              vim.cmd.Format()
            end
          end

          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
            vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Find references' })) -- Documentation & Signature
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Show hover doc' }))
          vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
          vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format(fmt_opts) end,
            vim.tbl_extend('force', opts, { desc = 'Format' }))
          vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code actions' }))

          vim.keymap.set({ 'n', 'x' }, '<space>gq', function()
            lsp_buf_format_with_fallback(client)
          end, vim.tbl_extend('force', opts, { desc = 'Format with fallback' }))
        end
      })

      -- Add dynamic diagnostic signs (icons, colors)
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
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
