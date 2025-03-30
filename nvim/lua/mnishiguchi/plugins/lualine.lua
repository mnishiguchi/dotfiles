-- Set lualine as statusline
return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      globalstatus = true,
      icons_enabled = true,
      theme = "auto",
      component_separators = "|",
      section_separators = "",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        {
          "filename",
          file_status = true, -- displays file status (readonly status, modified status)
          path = 0,           -- 0 = just filename, 1 = relative path, 2 = absolute path
        },
        {
          function()
            local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
            if not buf_clients or vim.tbl_isempty(buf_clients) then
              return "No LSP"
            end

            local client_names = {}
            for _, client in pairs(buf_clients) do
              table.insert(client_names, client.name)
            end

            return table.concat(client_names, ", ")
          end,
          cond = function()
            return vim.bo.filetype ~= "" and vim.api.nvim_get_current_buf() ~= nil
          end,
        },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = {
      "fugitive",
      "quickfix",
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
