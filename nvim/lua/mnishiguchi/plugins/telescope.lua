return {
  {
    -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
          -- https://www.reddit.com/r/neovim/comments/ymb8zx/comment/iv412oy/
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
        },
      })

      -- Enable telescope fzf native, if installed
      pcall(require("telescope").load_extension, "fzf")

      -- Keybindings
      local telescope_builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>fg", function()
        telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end, { desc = "[f]ind [g]rep" })
      vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "[f]ind [f]iles" })
      vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "[f]ind [b]uffers" })
      vim.keymap.set("n", "<leader>fm", telescope_builtin.marks, { desc = "[f]ind [m]arks" })
      vim.keymap.set("n", "<leader>fr", telescope_builtin.registers, { desc = "[f]ind [r]egisters" })
      vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "[f]ind [h]elp" })
      vim.keymap.set("n", "<leader>fq", telescope_builtin.quickfix, { desc = "[f]ind [q]uickfix items" })
      vim.keymap.set("n", "<leader>km", telescope_builtin.keymaps, { desc = "List [k]ey [m]aps" })
      vim.keymap.set("n", "<leader>?", telescope_builtin.oldfiles, { desc = "List recently opened files" })
      vim.keymap.set("n", "<leader>/", function()
        telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] fuzzily search in current buffer" })
      vim.keymap.set("n", "<leader>gf", telescope_builtin.git_files, { desc = "[g]it [f]iles" })
      vim.keymap.set("n", "<leader>gb", telescope_builtin.git_branches, { desc = "[g]it [b]ranches" })
      vim.keymap.set("n", "<leader>gc", telescope_builtin.git_commits, { desc = "[g]it [c]ommits" })
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  }
}
