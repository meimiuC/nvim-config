-- ~/.config/nvim/lua/core/basic.lua

-- 行号设置
vim.opt.number = true
vim.opt.relativenumber = true

-- 高亮设置
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

-- 色彩设置
vim.opt.termguicolors = true

-- 缩进设置 (Tab = 4 空格)
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- LSP config
vim.opt.signcolumn = "yes"

-- 其他
vim.opt.autoread = true

-- Mouse Support
vim.opt.mouse = "a"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

