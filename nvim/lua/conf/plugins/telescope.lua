return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    require("telescope").setup({})

    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<leader>fg", builtin.git_files)
    vim.keymap.set("n", "<leader>fr", builtin.live_grep)
    vim.keymap.set("n", "<leader>ff", builtin.find_files)
    vim.keymap.set("n", "<leader>fb", builtin.buffers)
    vim.keymap.set("n", "<leader>fh", ":Telescope find_files hidden=true<CR>")

    vim.keymap.set("n", "<leader>fF", function()
      require("telescope.builtin").find_files({
        cwd = vim.fn.input("Search dir: ", vim.fn.getcwd() .. "/", "dir"),
      })
    end, { desc = "Find files in chosen directory" })
  end,
}

