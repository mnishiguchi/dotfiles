-- Highlight, edit, and navigate code
return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    pcall(require("nvim-treesitter.install").update({ with_sync = true }))

    require("nvim-treesitter.configs").setup({
      -- A list of parsers that should always be installed
      ensure_installed = { "c", "elixir", "help", "javascript", "lua", "ruby", "vim" },
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
}
