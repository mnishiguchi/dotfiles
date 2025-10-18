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
      { "saghen/blink.cmp",                 version = "1.*" },
      { 'williamboman/mason.nvim' },           -- Mason: Automatic installation of LSP servers.
      { 'williamboman/mason-lspconfig.nvim' }, -- Bridges Mason with nvim-lspconfig.
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Define the list of LSP servers to install and configure.
      -- Ensure these identifiers match those used by Mason and lspconfig.
      local servers = {
        'bashls',
        'clangd',
        'cssls',
        'emmet_language_server',
        'gopls',
        'html',
        'jsonls',
        'lua_ls',
        'ruby_lsp',
        'rust_analyzer',
        'tailwindcss',
        'taplo',
        'ts_ls',
        'yamlls',
      }

      -- optional: prefer LSP formatting only for servers you want, else fall back to Conform
      -- here we disable formatting for ts/css/html/json/yaml (prettier-land) and ruby (rbprettier/rubocop)
      local disable_fmt = {
        cssls = true,
        html = true,
        jsonls = true,
        ruby_lsp = true,
        ts_ls = true,
        tsserver = true,
        yamlls = true,
      }

      ------------------------------------------------------------------------------
      -- Mason Setup: Automatic LSP Server Installation
      ------------------------------------------------------------------------------
      -- This handler is invoked for every LSP server that Mason installs.
      -- It merges default capabilities with any custom configuration found in
      -- 'nvim/lsp/<server>.lua', sets up the server via lspconfig, and then registers
      -- the server with Neovim's native LSP manager.
      ------------------------------------------------------------------------------
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = servers,
        handlers = {
          -- default handler for all installed servers
          function(server)
            local opts = { capabilities = capabilities }
            lspconfig[server].setup(opts)
            vim.lsp.enable(server)
          end,
        },
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

          -- Prefer LSP formatting only for servers you want, else fall back to Conform
          if disable_fmt[client.name] then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end

          -- Enable inlay hints if supported
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
          end

          local opts = { buffer = event.buf }

          -- Function to attempt formatting with the LSP server, with a fallback option.
          local function lsp_buf_format_with_fallback()
            if client.server_capabilities.documentFormattingProvider then
              vim.notify('Using ' .. client.name .. ' for formatting', vim.log.levels.INFO)
              vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
            else
              vim.notify('Using conform.nvim for formatting', vim.log.levels.INFO)
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
          vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action,
            vim.tbl_extend('force', opts, { desc = 'Code actions' }))
          vim.keymap.set({ 'n', 'x' }, '<space>lf', lsp_buf_format_with_fallback,
            vim.tbl_extend('force', opts, { desc = 'Format with fallback' }))
        end
      })

      ------------------------------------------------------------------------------
      -- Diagnostic Config: global behavior for virtual text, sorting, updates
      ------------------------------------------------------------------------------
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = { spacing = 2, prefix = "●" },
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
  -- Autocompletion & Snippet Configuration Block (blink.cmp + LuaSnip)
  ------------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    version      = "1.*",
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "v2.*" }, -- snippet engine
      "rafamadriz/friendly-snippets"            -- snippet collection
    },
    config       = function(_, opts)
      local luasnip = require("luasnip")
      luasnip.setup {
        history      = true,
        updateevents = "TextChanged,TextChangedI",
      }

      require("luasnip.loaders.from_vscode").lazy_load()

      vim.keymap.set({ "i", "s" }, "<C-k>", function()
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          end
        end,
        { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { silent = true })

      require("blink.cmp").setup({
        keymap     = {
          preset = "super-tab",
        },
        snippets   = { preset = "luasnip" },
        appearance = { nerd_font_variant = "mono" },
        completion = { documentation = { auto_show = true } },
        sources    = { default = { "lsp", "path", "snippets", "buffer" } },
        fuzzy      = { implementation = "prefer_rust_with_warning" },
      })
    end,
  },
}
