return {
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  cmd = {
    "clangd",
    "--background-index",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--fallback-style=LLVM",
    "--all-scopes-completion",
    -- Uncomment to enable clang-tidy checks if you have a .clang-tidy:
    -- "--clang-tidy",
  },
  -- You’re already merging default capabilities in your handler.
}
