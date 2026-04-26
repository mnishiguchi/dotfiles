return {
	filetypes = {
		-- CSS
		"css",
		"less",
		"sass",
		"scss",

		-- HTML / templates
		"html",
		"eruby",

		-- Elixir / Phoenix
		"elixir",
		"eelixir",
		"heex",

		-- JavaScript / TypeScript
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",

		-- Frontend frameworks
		"vue",
		"svelte",

		-- Markdown
		"markdown",
		"markdown.mdx",
	},

	settings = {
		tailwindCSS = {
			includeLanguages = {
				eelixir = "html-eex",
				elixir = "phoenix-heex",
				eruby = "erb",
				heex = "phoenix-heex",
				["markdown.mdx"] = "mdx",
			},
		},
	},
}
