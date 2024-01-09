-- https://github.com/mvllow/modes.nvim
return {
  "mvllow/modes.nvim",
  opts = {
    line_opacity = 0.12,

    -- Disable modes highlights in specified filetypes
    ignore_filetypes = {
      'NvimTree',
      'TelescopePrompt',
    }
  },
}
