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
					path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
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
