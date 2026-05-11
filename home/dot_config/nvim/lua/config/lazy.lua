-- Bootstrap lazy.nvim (the plugin manager) and load LazyVim.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        -- LazyVim core + curated plugin spec
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- Local overrides / extras
        { import = "plugins" },
    },
    defaults = {
        -- Eager-load our own plugins; LazyVim's are still lazy by default.
        lazy = false,
        -- Always pin to upstream HEAD on stable branch; lazy-lock.json
        -- (committed alongside this file) is what gives us reproducibility.
        version = false,
    },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = true, notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
