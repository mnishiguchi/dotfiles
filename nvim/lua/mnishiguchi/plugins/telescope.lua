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

      -- Keybindings
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")
      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List open buffers", unpack(opts) })
      vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Search available Vim commands", unpack(opts) })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Search LSP diagnostics", unpack(opts) })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files in the workspace", unpack(opts) })
      vim.keymap.set("n", "<leader>fg", function()
        builtin.grep_string({ search = vim.fn.input("Grep> ") })
      end, { desc = "Search for text in the workspace", unpack(opts) })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help documentation", unpack(opts) })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "List all key mappings", unpack(opts) })
      vim.keymap.set("n", "<leader>fl", builtin.live_grep, { desc = "Live grep across the workspace", unpack(opts) })
      vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Find marks in the workspace", unpack(opts) })
      vim.keymap.set("n", "<leader>fo", builtin.vim_options, { desc = "Search and tweak Vim options", unpack(opts) })
      vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Search the quickfix list", unpack(opts) })
      vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "List Vim registers", unpack(opts) })
      vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "List Git branches", unpack(opts) })
      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "View Git commit history", unpack(opts) })
      vim.keymap.set("n", "<leader>gd", builtin.git_status, { desc = "View Git changes and diffs", unpack(opts) })
      vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Find files in the Git repository", unpack(opts) })
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Reopen recently used files", unpack(opts) })
      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(themes.get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "Fuzzy search in the current buffer", unpack(opts) })
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
