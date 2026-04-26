# after/lsp

This directory is reserved for local Neovim LSP config overrides.

Server configs should only be added here when they intentionally override or
extend the defaults provided by nvim-lspconfig. For normal server setup, prefer
the upstream server definition. Keep language-specific project settings in
project-local configuration files when available, such as `.luarc.json` for Lua.
