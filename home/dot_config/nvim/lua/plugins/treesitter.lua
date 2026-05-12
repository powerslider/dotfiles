-- Extra Tree-sitter parsers. LazyVim ships a base set. Add the ones we
-- care about that aren't always pulled in by default.
--
-- gitcommit + diff give us syntax-highlighted commit-message editing
-- when `commit.verbose = true` is set in ~/.gitconfig.
return {
    { "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, {
              "gitcommit",
              "diff",
              "git_config",
              "git_rebase",
              "gitattributes",
              "gitignore",
          })
      end,
    },
}
