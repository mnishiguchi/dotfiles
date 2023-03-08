local lsp = require('lsp-zero')

lsp.preset('recommended')

pcall(lsp.setup)
