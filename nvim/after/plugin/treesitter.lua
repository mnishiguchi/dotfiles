pcall(require('nvim-treesitter.install').update({ with_sync = true }))

require('nvim-treesitter.configs').setup({
  -- A list of parsers that should always be installed
  ensure_installed = {
    'c',
    'elixir',
    'erlang',
    'help',
    'javascript',
    'lua',
    'ruby',
    'typescript',
    'vim',
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
