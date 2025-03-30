return {
  filetypes = { "css", "scss", "less" },
  settings = {
    css = {
      lint = {
        unknownAtRules = "ignore", -- Prevent lint warning on e.g. @tailwind
      },
    },
  },
}
