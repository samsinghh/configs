return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  -- lazy-load Trouble when you press any of these keys
  keys = {
    {
      "<leader>xx",
      function()
        require("trouble").toggle({ mode = "diagnostics" })
      end,
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      function()
        require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
      end,
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>xt",
      function()
        require("trouble").toggle({ mode = "test" })
      end,
      desc = "Diagnostics + Preview (Trouble)",
    },
    {
      "<leader>cs",
      function()
        require("trouble").toggle({ mode = "symbols", focus = false })
      end,
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      function()
        require("trouble").toggle({ mode = "lsp", focus = false, win = { position = "right" } })
      end,
      desc = "LSP (Trouble)",
    },
    {
      "<leader>xL",
      function()
        require("trouble").toggle({ mode = "loclist" })
      end,
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      function()
        require("trouble").toggle({ mode = "qflist" })
      end,
      desc = "Quickfix List (Trouble)",
    },
  },

  opts = {
    modes = {
      test = {
        mode = "diagnostics",
        preview = {
          type = "split",
          relative = "win",
          position = "right",
          size = 0.3,
        },
      },
    },
  },
}

