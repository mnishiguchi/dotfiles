return {
	------------------------------------------------------------------------------
	-- Theme
	------------------------------------------------------------------------------
	{
		"marko-cerovac/material.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			vim.g.material_style = "deep ocean"
		end,
		config = function()
			require("material").setup({
				plugins = {
					"blink",
					"gitsigns",
					"harpoon",
					"indent-blankline",
					"nvim-web-devicons",
					"telescope",
					"which-key",
				},
			})

			local colorscheme = "material"
			local status_ok = pcall(vim.cmd.colorscheme, colorscheme)
			if not status_ok then
				vim.notify("colorscheme " .. colorscheme .. " not found", vim.log.levels.WARN)
			end
		end,
	},

	------------------------------------------------------------------------------
	-- UI
	------------------------------------------------------------------------------
	{
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
						file_status = true,
						path = 0,
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
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			local highlight = {
				"RainbowBrown",
				"RainbowBeige",
				"RainbowCoolGray",
				"RainbowSlateGray",
				"RainbowDarkSlate",
				"RainbowCharcoal",
			}

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowBrown", { fg = "#8D6E63" })
				vim.api.nvim_set_hl(0, "RainbowBeige", { fg = "#A1887F" })
				vim.api.nvim_set_hl(0, "RainbowCoolGray", { fg = "#B0BEC5" })
				vim.api.nvim_set_hl(0, "RainbowSlateGray", { fg = "#78909C" })
				vim.api.nvim_set_hl(0, "RainbowDarkSlate", { fg = "#546E7A" })
				vim.api.nvim_set_hl(0, "RainbowCharcoal", { fg = "#37474F" })
			end)

			require("ibl").setup({ indent = { highlight = highlight } })
		end,
	},

	------------------------------------------------------------------------------
	-- Editing helpers
	------------------------------------------------------------------------------
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup()
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"vimwiki/vimwiki",
		init = function()
			vim.g.vimwiki_list = {
				{
					path = "~/Documents/vimwiki/",
					syntax = "markdown",
					ext = ".md",
				},
			}

			vim.g.vimwiki_global_ext = 0
		end,
	},
	{ "tpope/vim-abolish", event = "VeryLazy" },

	------------------------------------------------------------------------------
	-- Git
	------------------------------------------------------------------------------
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = ":Git status" })
			vim.keymap.set("n", "<leader>gw", ":Gwrite<CR>", { desc = ":Git write (add current file)" })
			vim.keymap.set("n", "<leader>gr", ":Gread<CR>", { desc = ":Git read (replace current file)" })
		end,
	},
	{
		"tpope/vim-rhubarb",
		event = "VeryLazy",
		dependencies = { "tpope/vim-fugitive" },
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"f-person/git-blame.nvim",
		config = function()
			vim.g.gitblame_date_format = "%r"
		end,
	},

	------------------------------------------------------------------------------
	-- Project navigation
	------------------------------------------------------------------------------
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Add Harpoon mark" })

			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Open Harpoon menu" })

			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end, { desc = "Jump to 1st Harpoon mark" })
			vim.keymap.set("n", "<C-t>", function()
				harpoon:list():select(2)
			end, { desc = "Jump to 2nd Harpoon mark" })
			vim.keymap.set("n", "<C-n>", function()
				harpoon:list():select(3)
			end, { desc = "Jump to 3rd Harpoon mark" })
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_config = {
						prompt_position = "top",
					},
				},
			})

			pcall(telescope.load_extension, "fzf")

			local builtin = require("telescope.builtin")
			local themes = require("telescope.themes")
			local opts = { noremap = true, silent = true }

			local function keymap_opts(desc)
				return vim.tbl_extend("force", opts, { desc = desc })
			end

			vim.keymap.set("n", "<leader>fb", builtin.buffers, keymap_opts("List open buffers"))
			vim.keymap.set("n", "<leader>fc", builtin.commands, keymap_opts("Search available Vim commands"))
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, keymap_opts("Search LSP diagnostics"))
			vim.keymap.set("n", "<leader>ff", builtin.find_files, keymap_opts("Find files in the workspace"))
			vim.keymap.set("n", "<leader>fg", function()
				builtin.grep_string({ search = vim.fn.input("Grep> ") })
			end, keymap_opts("Search for text in the workspace"))
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, keymap_opts("Search help documentation"))
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, keymap_opts("List all key mappings"))
			vim.keymap.set("n", "<leader>fl", builtin.loclist, keymap_opts("Search the location list"))
			vim.keymap.set("n", "<leader>fm", builtin.marks, keymap_opts("Find marks in the workspace"))
			vim.keymap.set("n", "<leader>fo", builtin.vim_options, keymap_opts("Search and tweak Vim options"))
			vim.keymap.set("n", "<leader>fq", builtin.quickfix, keymap_opts("Search the quickfix list"))
			vim.keymap.set("n", "<leader>fr", builtin.registers, keymap_opts("List Vim registers"))
			vim.keymap.set("n", "<leader>gb", builtin.git_branches, keymap_opts("List Git branches"))
			vim.keymap.set("n", "<leader>gc", builtin.git_commits, keymap_opts("View Git commit history"))
			vim.keymap.set("n", "<leader>gd", builtin.git_status, keymap_opts("View Git changes and diffs"))
			vim.keymap.set("n", "<leader>gf", builtin.git_files, keymap_opts("Find files in the Git repository"))
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, keymap_opts("Reopen recently used files"))
			vim.keymap.set("n", "<leader>?", builtin.live_grep, keymap_opts("Live grep across the workspace"))
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(themes.get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, keymap_opts("Fuzzy search in the current buffer"))
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},

	------------------------------------------------------------------------------
	-- Treesitter
	------------------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		version = false,
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			local languages = {
				"bash",
				"c",
				"cpp",
				"css",
				"elixir",
				"heex",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"ruby",
				"rust",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}

			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			ts.install(languages)

			vim.treesitter.language.register("html", { "blade", "eruby" })
			vim.treesitter.language.register("bash", { "sh", "tmux" })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"c",
					"cpp",
					"css",
					"eelixir",
					"elixir",
					"heex",
					"html",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown.mdx",
					"ruby",
					"rust",
					"sh",
					"toml",
					"typescript",
					"vim",
					"vimdoc",
					"yaml",

					-- Custom mappings
					"blade",
					"eruby",
					"tmux",
				},
				callback = function(args)
					if vim.b[args.buf].large_file then
						return
					end

					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},

	------------------------------------------------------------------------------
	-- Formatting
	------------------------------------------------------------------------------
	{
		"stevearc/conform.nvim",
		init = function()
			local function format(options)
				require("conform").format(vim.tbl_extend("force", {
					lsp_format = "fallback",
				}, options or {}))
			end

			vim.api.nvim_create_user_command("Format", function()
				format({
					async = true,
				})
			end, { desc = "Format buffer" })

			vim.keymap.set({ "n", "x" }, "<leader>lf", "<cmd>Format<CR>", {
				desc = "Format buffer",
			})

			vim.api.nvim_create_user_command("FormatWrite", function()
				format({
					async = false,
					timeout_ms = 3000,
				})
				vim.cmd.write()
			end, { desc = "Format and write buffer" })
		end,
		config = function()
			local util = require("conform.util")

			local prettier_config_file_names = {
				".prettierrc",
				".prettierrc.json",
				".prettierrc.yml",
				".prettierrc.yaml",
				".prettierrc.json5",
				".prettierrc.js",
				".prettierrc.cjs",
				".prettierrc.mjs",
				".prettierrc.toml",
				"prettier.config.js",
				"prettier.config.cjs",
				"prettier.config.mjs",
			}

			require("conform").setup({
				format_on_save = function(bufnr)
					if vim.b[bufnr].large_file then
						return
					end

					return {
						lsp_format = "fallback",
						timeout_ms = 3000,
					}
				end,
				formatters = {
					["clang-format"] = {
						command = "clang-format",
						args = { "--assume-filename", "$FILENAME" },
						stdin = true,
					},
					mbake = {
						command = "mbake",
						args = { "format", "$FILENAME" },
						stdin = false,
					},
					rbprettier = {
						command = "bundle",
						args = { "exec", "rbprettier", "--stdin-filepath", "$FILENAME" },
						stdin = true,
						condition = function()
							return util.root_file(prettier_config_file_names) ~= nil
						end,
					},
				},
				formatters_by_ft = {
					c = { "clang-format" },
					cmake = { "gersemi" },
					cpp = { "clang-format" },
					css = { "prettierd" },
					elixir = { "mix" },
					eruby = { "htmlbeautifier" },
					fish = { "fish_indent" },
					go = { "goimports", "gofumpt" },
					gomod = { "goimports", "gofumpt" },
					gotmpl = { "goimports", "gofumpt" },
					gowork = { "goimports", "gofumpt" },
					graphql = { "prettierd" },
					html = { "prettierd" },
					javascript = { "prettierd" },
					javascriptreact = { "prettierd" },
					json = { "prettierd" },
					lua = { "stylua" },
					make = { "mbake" },
					markdown = { "prettierd" },
					ruby = { "rbprettier", "rubocop" },
					sh = { "shfmt" },
					toml = { "taplo" },
					typescript = { "prettierd" },
					typescriptreact = { "prettierd" },
					xml = { "xmllint" },
					yaml = { "prettierd" },

					-- Run only when no filetype-specific formatter is configured.
					["_"] = { "trim_whitespace" },
				},
			})
		end,
	},

	------------------------------------------------------------------------------
	-- LSP
	------------------------------------------------------------------------------
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"bashls",
				"clangd",
				"expert",
				"gopls",
				"jsonls",
				"lua_ls",
				"ruby_lsp",
				"taplo",
				"yamlls",
			},
			automatic_enable = {
				exclude = {
					"stylua",
				},
			},
		},
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				-- Formatters used by conform.nvim
				"stylua",
				"prettierd",
				"clang-format",
				"gersemi",
				"mbake",
				"htmlbeautifier",
				"shfmt",

				-- Go
				"gofumpt",
				"goimports",
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lsp_attach_augroup = vim.api.nvim_create_augroup("mnishiguchi_lsp_attach", {
				clear = true,
			})

			-- Neovim already provides default LSP mappings such as K, grn, gra,
			-- grr, gri, grt, grx, and gO. Keep only custom mappings that add value.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = lsp_attach_augroup,
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if not client then
						return
					end

					local opts = { buffer = event.buf }

					local function lsp_keymap(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
					end

					if client.server_capabilities.inlayHintProvider then
						lsp_keymap("n", "<leader>lh", function()
							local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
							vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
						end, "Toggle inlay hints")
					end

					lsp_keymap("n", "gd", vim.lsp.buf.definition, "Go to definition")
					lsp_keymap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				end,
			})

			local function show_diagnostic_on_jump(diagnostic, bufnr)
				if not diagnostic then
					return
				end

				vim.diagnostic.show(diagnostic.namespace, bufnr, { diagnostic }, {
					virtual_lines = { current_line = true },
					virtual_text = false,
				})
			end

			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				virtual_text = false,
				virtual_lines = false,
				float = {
					source = "if_many",
				},
				jump = {
					on_jump = show_diagnostic_on_jump,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
					numhl = {
						[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
						[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
						[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
						[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					},
				},
			})
		end,
	},

	------------------------------------------------------------------------------
	-- Completion
	------------------------------------------------------------------------------
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("blink.cmp").setup({
				keymap = {
					preset = "super-tab",
				},
				appearance = { nerd_font_variant = "mono" },
				completion = { documentation = { auto_show = true } },
				sources = { default = { "lsp", "path", "snippets", "buffer" } },
				fuzzy = { implementation = "prefer_rust_with_warning" },
			})
		end,
	},
}
