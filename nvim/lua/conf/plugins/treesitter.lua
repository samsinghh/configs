return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag", -- auto-close/auto-rename HTML/JSX/TSX tags
  },

  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = {
        "c",
        "cpp",
        "python",
        "html",
        "css",
        "matlab",
        "javascript",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "tsx",
        "typescript",
      },

      sync_install = false,
      auto_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
      },

      -- This is for character pairs, not HTML tags, but leaving it enabled is fine.
      autopairs = {
        enable = true,
      },

      -- HTML/JSX/TSX tag closing
      autotag = {
        enable = true,
      },
    })

    require("nvim-ts-autotag").setup()
  end,
}

