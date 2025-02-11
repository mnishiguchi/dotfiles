-- https://github.com/goolord/alpha-nvim
return {
  "goolord/alpha-nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      " ________   _______   ________  ___      ___ ___  _____ ______",
      "|\\   ___  \\|\\  ___ \\ |\\   __  \\|\\  \\    /  /|\\  \\|\\   _ \\  _   \\",
      "\\ \\  \\\\ \\  \\ \\   __/|\\ \\  \\|\\  \\ \\  \\  /  / | \\  \\ \\  \\\\\\__\\ \\  \\",
      " \\ \\  \\\\ \\  \\ \\  \\_|/_\\ \\  \\\\\\  \\ \\  \\/  / / \\ \\  \\ \\  \\\\|__| \\  \\",
      "  \\ \\  \\\\ \\  \\ \\  \\_|\\ \\ \\  \\\\\\  \\ \\    / /   \\ \\  \\ \\  \\    \\ \\  \\",
      "   \\ \\__\\\\ \\__\\ \\_______\\ \\_______\\ \\__/ /     \\ \\__\\ \\__\\    \\ \\__\\",
      "    \\|__| \\|__|\\|_______|\\|_______|\\|__|/       \\|__|\\|__|     \\|__|",
    }

    dashboard.section.buttons.val = {
      dashboard.button("n", "  New File", ":ene<CR>"),
      dashboard.button("p", "  Find Project", ":Telescope projects<CR>"),
      dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
      dashboard.button("c", "  Edit Config", ":e $MYVIMRC<CR>"),
      dashboard.button("u", "  Update Plugins", ":Lazy sync<CR>"),
      dashboard.button("q", "󰅚  Quit Neovim", ":qa<CR>"),
    }

    alpha.setup(dashboard.opts)

    -- Disable folding in alpha buffer
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      command = "setlocal nofoldenable",
    })
  end,
}
