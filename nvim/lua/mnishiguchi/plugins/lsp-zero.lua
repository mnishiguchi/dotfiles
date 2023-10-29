-- A starting point to setup some LSP related features
return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v3.x",
  config = function()
    local lsp_zero = require("lsp-zero")

    -- see :help lsp-zero-keybindings for available actions
    local function setup_keybindings()
      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false -- force lsp-zero's bindings
        })
      end)
    end

    local function setup_lsp_servers()
      require("mason").setup({})

      require("mason-lspconfig").setup({
        -- list the language servers you want to to be installed automatically
        ensure_installed = {},
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
          tsserver = lsp_zero.noop,
        },
      })
    end

    local function setup_autocompletion()
      local cmp = require("cmp")

      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip", keyword_length = 2 },
          { name = "buffer",  keyword_length = 5 },
        }, {
        }),
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        })
      })
    end

    setup_keybindings()
    setup_lsp_servers()
    setup_autocompletion()
  end,
  dependencies = {
    -- LSP support
    "neovim/nvim-lspconfig",
    "williamboman/mason-lspconfig.nvim",
    "williamboman/mason.nvim",

    -- Autocompletion
    -- https://github.com/hrsh7th/nvim-cmp
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",

    -- Snippet engine
    -- https://github.com/L3MON4D3/LuaSnip
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        {
          -- https://github.com/rafamadriz/friendly-snippets
          "rafamadriz/friendly-snippets",
          init = function()
            require("luasnip.loaders.from_vscode").lazy_load()

            -- add html snippets to other languages
            require("luasnip").filetype_extend("elixir", { "html" })
            require("luasnip").filetype_extend("erb", { "html" })
            require("luasnip").filetype_extend("heex", { "html" })
            require("luasnip").filetype_extend("leex", { "html" })
          end,
        },
      },
    },
  },
}
