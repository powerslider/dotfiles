-- Pin tokyonight as the default colorscheme (LazyVim's default too,
-- but stating it explicitly keeps overrides discoverable).
return {
    { "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = { style = "storm" },
    },
    { "LazyVim/LazyVim",
      opts = {
          colorscheme = "tokyonight",
      },
    },
}
