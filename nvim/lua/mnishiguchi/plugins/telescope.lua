return {
  {
    -- Telescope: Fuzzy Finder for files, LSP, and more
    "nvim-telescope/telescope.nvim",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          sorting_strategy = "ascending", -- Show results from top to bottom
          layout_config = {
            prompt_position = "top",      -- Move prompt to the top
          },
        },
      })

      -- Enable telescope fzf native, if installed
      pcall(telescope.load_extension, "fzf")

      -- https://github.com/ahmedkhalf/project.nvim#telescope-integration
      pcall(telescope.load_extension, "projects")

      -- Keybindings
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
      "nvim-lua/plenary.nvim", -- Required dependency for Telescope
    },
  },
  {
    -- Fuzzy Finder Algorithm using native dependencies
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",                         -- Requires `make` to build
    cond = function()
      return vim.fn.executable("make") == 1 -- Only load if `make` is available
    end,
  },
}
