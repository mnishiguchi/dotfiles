local lsp = require('lsp-zero')

lsp.preset('recommended')

if pcall(lsp.setup) then
  print('lsp-zero configured successfully')
else
  print('error configuring lsp-zero')
end
