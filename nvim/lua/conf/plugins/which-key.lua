return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  config = function()
    require("which-key").setup({
      plugins = {
        spelling = { enabled = true },
      },
      win = {
        border = "rounded",
      },
    })

    -- Optional: name your leader groups so they look clean
    local wk = require("which-key")

    wk.add({
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>c", group = "code" },
      { "<leader>x", group = "diagnostics" },
      { "<leader>b", group = "buffers" },
      { "<leader>w", group = "windows" },
      { "<leader>t", group = "toggles" },
      { "<leader>s", group = "search" }, 
    })
  end,
}
