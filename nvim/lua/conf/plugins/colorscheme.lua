return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load before everything else
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        integrations = {
          treesitter = true,
          lsp_trouble = true,
          telescope = true,
          cmp = true,
          gitsigns = true,
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

