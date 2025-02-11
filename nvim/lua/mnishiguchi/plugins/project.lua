return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup {
      detection_methods = { "lsp", "pattern" },
      patterns = {
        ".git",         -- Git-based projects
        "mix.exs",      -- Elixir
        "Gemfile",      -- Ruby
        "package.json", -- JS, TS, React, React Native
        "pubspec.yaml", -- Flutter
        "go.mod",       -- Go
        "Cargo.toml",   -- Rust
        "build.zig"     -- Zig
      }
    }
  end
}
