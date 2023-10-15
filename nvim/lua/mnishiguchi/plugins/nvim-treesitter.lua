-- Highlight, edit, and navigate code
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- A list of parsers that should always be installed
      ensure_installed = { "c", "elixir", "javascript", "lua", "ruby", "vim", "vimdoc" },
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      -- List of parsers to ignore installing (or "all")
      ignore_install = { "help" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
}
