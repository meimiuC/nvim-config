-- ~/.config/nvim/lua/core/lazy.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 自动引导安装
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 启动 Lazy，并告诉它去 lua/plugins 目录找插件
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
})
