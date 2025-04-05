-- A starting point for setting up LSP, completion, and snippet features in Neovim.
-- This configuration leverages Mason for automatic LSP server installation,
-- uses Neovim 0.11's native LSP manager, and combines nvim-cmp with LuaSnip for
-- completion and snippet support.
return {
  ------------------------------------------------------------------------------
  -- LSP Configuration Block
  ------------------------------------------------------------------------------
  {
    'neovim/nvim-lspconfig',
    -- These commands and events allow lazy-loading of the LSP configuration.
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },              -- Integration with nvim-cmp for LSP-based completion.
      { 'williamboman/mason.nvim' },           -- Mason: Automatic installation of LSP servers.
      { 'williamboman/mason-lspconfig.nvim' }, -- Bridges Mason with nvim-lspconfig.
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities() -- Enable nvim-cmp LSP completion support

      -- Define the list of LSP servers to install and configure.
      -- Ensure these identifiers match those used by Mason and lspconfig.
      local servers = {
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

      ------------------------------------------------------------------------------
      -- Mason Setup: Automatic LSP Server Installation
      ------------------------------------------------------------------------------
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = servers, -- Automatically install these servers if they are missing.
      })

      ------------------------------------------------------------------------------
      -- Mason LSPConfig Handlers: Unified Server Setup
      ------------------------------------------------------------------------------
      -- This handler is invoked for every LSP server that Mason installs.
      -- It merges default capabilities with any custom configuration found in
      -- 'nvim/lsp/<server>.lua', sets up the server via lspconfig, and then registers
      -- the server with Neovim's native LSP manager.
      require('mason-lspconfig').setup_handlers({
        function(server)
          local opts = { capabilities = capabilities }
          local has_custom, custom_opts = pcall(require, "lsp." .. server)
          if has_custom then
            opts = vim.tbl_deep_extend("force", opts, custom_opts)
          end
          lspconfig[server].setup(opts)
          vim.lsp.enable(server) -- Register the server with Neovim's native LSP manager.
        end,
      })

      ------------------------------------------------------------------------------
      -- Autocommand: LspAttach for Buffer-local Keymaps and Notifications
      ------------------------------------------------------------------------------
      -- When an LSP server attaches to a buffer, this autocommand sets up helpful key
      -- mappings and displays a notification indicating which server has been attached.
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local client = vim.lsp.get_clients({ id = event.data.client_id })[1]
          if not client then return end

          local opts = { buffer = event.buf }

          -- Function to attempt formatting with the LSP server, with a fallback option.
          local function lsp_buf_format_with_fallback(client)
            if client.server_capabilities.documentFormattingProvider then
              vim.notify('Using ' .. client.name .. ' for formatting', vim.log.levels.INFO)
              vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
            else
              vim.notify('Using formatter.nvim for formatting', vim.log.levels.INFO)
              vim.cmd.Format()
            end
          end

          -- Define key mappings for common LSP actions.
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
            vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
            vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
          vim.keymap.set('n', 'gr', vim.lsp.buf.references,
            vim.tbl_extend('force', opts, { desc = 'Find references' }))
          vim.keymap.set('n', 'K', vim.lsp.buf.hover,
            vim.tbl_extend('force', opts, { desc = 'Show hover documentation' }))
          vim.keymap.set('n', '<F2>', vim.lsp.buf.rename,
            vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
          vim.keymap.set({ 'n', 'x' }, '<F3>', function() lsp_buf_format_with_fallback(client) end,
            vim.tbl_extend('force', opts, { desc = 'Format code' }))
          vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action,
            vim.tbl_extend('force', opts, { desc = 'Code actions' }))
          vim.keymap.set({ 'n', 'x' }, '<space>gq', function() lsp_buf_format_with_fallback(client) end,
            vim.tbl_extend('force', opts, { desc = 'Format with fallback' }))
        end
      })

      ------------------------------------------------------------------------------
      -- Diagnostic Signs: Visual Indicators for LSP Diagnostics
      ------------------------------------------------------------------------------
      -- Define custom signs (icons) for errors, warnings, hints, and informational messages.
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  ------------------------------------------------------------------------------
  -- Autocompletion & Snippet Configuration Block (nvim-cmp + LuaSnip)
  ------------------------------------------------------------------------------
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    -- Nesting LuaSnip as a dependency to group completion and snippet configurations.
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = "v2.*",
        dependencies = {
          -- This plugin bridges LuaSnip with nvim-cmp to make snippets available as completion suggestions.
          "saadparwaiz1/cmp_luasnip",
          -- Provides a collection of ready-to-use snippets for various languages.
          'rafamadriz/friendly-snippets',
        },
        config = function(_, opts)
          if opts then require('luasnip').config.setup(opts) end
          -- Lazy-load snippets in VSCode snippet format.
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        -- Configure the sources for completion suggestions.
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },                    -- LSP-based completions.
          { name = 'path' },                        -- Filesystem paths.
          { name = 'luasnip', keyword_length = 2 }, -- Snippet completions.
          { name = 'buffer',  keyword_length = 5 }, -- Buffer text completions.
        }),
        -- Define key mappings for navigating and confirming completion items.
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item({ behavior = 'select' }),   -- Select next item.
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }), -- Select previous item.
          ['<CR>'] = cmp.mapping.confirm({ select = false }),                  -- Confirm selection.
        }),
        -- Specify the snippet expansion function.
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        -- Configure bordered windows for a polished UI.
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
}
