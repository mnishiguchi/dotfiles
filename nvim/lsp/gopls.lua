return {
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      usePlaceholders = true,
      completeUnimported = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

