-- Material colorscheme. Variants: "darker" | "lighter" | "oceanic"
-- | "palenight" | "deep ocean". Change `vim.g.material_style` to swap.
return {
    { "marko-cerovac/material.nvim",
      lazy = false,
      priority = 1000,
      config = function()
          vim.g.material_style = "oceanic"
          require("material").setup({
              contrast = {
                  terminal       = true,
                  sidebars       = true,
                  floating_windows = true,
                  cursor_line    = false,
                  lsp_virtual_text = true,
                  non_current_windows = false,
                  filetypes      = {},
              },
              styles = {
                  comments  = { italic = true },
                  strings   = {},
                  keywords  = { bold   = true },
                  functions = {},
                  variables = {},
                  operators = {},
                  types     = {},
              },
              plugins = {
                  "gitsigns", "nvim-cmp", "nvim-tree", "nvim-web-devicons",
                  "telescope", "trouble", "which-key", "indent-blankline",
              },
              disable = {
                  colored_cursor = false,
                  borders        = false,
                  background     = false,
                  term_colors    = false,
                  eob_lines      = false,
              },
              high_visibility = {
                  lighter = false,
                  darker  = false,
              },
              lualine_style = "default",
          })
          vim.cmd.colorscheme("material")
      end,
    },
    { "LazyVim/LazyVim",
      opts = { colorscheme = "material" },
    },
}
