-- https://github.com/neovim/nvim-lspconfig/blob/ef40b787e68eb44b11e65596fdc46a1ad3445ccc/lsp/lua_ls.lua
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
}
