-- A starting point to setup some LSP related features
return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",
  config = function()
    local function setup_lsp()
      local lsp = require("lsp-zero").preset({})
      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
      end)
      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
      -- https://github.com/williamboman/mason-lspconfig.nvim
      lsp.ensure_installed({ "lua_ls" })

      lsp.setup()
    end

    -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/autocomplete.md#add-an-external-collection-of-snippets
    local function setup_autocompletion()
      local cmp = require("cmp")
      local cmp_action = require("lsp-zero").cmp_action()

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip", keyword_length = 2 },
          { name = "buffer",  keyword_length = 5 },
        },
        mapping = {
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        },
      })
    end

    setup_lsp()
    setup_autocompletion()
  end,
  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" }, -- Required
    { "williamboman/mason-lspconfig.nvim" },
    {
      "williamboman/mason.nvim",
      build = function()
        pcall(vim.cmd, "MasonUpdate")
      end,
    },

    -- Autocompletion
    "hrsh7th/nvim-cmp",   -- Required
    "hrsh7th/cmp-nvim-lsp", -- Required
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",

    -- Snippet engine
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        {
          -- https://github.com/rafamadriz/friendly-snippets
          "rafamadriz/friendly-snippets",
          init = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
    },
  },
}
