-- ~/.config/nvim/init.lua

-- 0. 先设置 Leader 键
-- 放在所有“按键映射定义之前
-- vim.g 可以理解成 “Neovim 的全局变量表”
-- vim.g.mapleader 将全局 Leader 键设置为空格
vim.g.mapleader = " "
-- vim.g.maplocalleader 设置“本地 Leader 键”，是给某些局部场景预留的 leader
vim.g.maplocalleader = " "

-- 1. 加载基础设置 (选项)
require("core.basic")

-- 禁用 Neovim 内置的文件浏览器 Netrw（为了让 nvim-tree 正常工作）
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 2. 加载快捷键 (按键映射)
-- require("core.keymaps")

-- 3. 加载插件管理器 (Lazy.nvim)
require("core.lazy")

-- 如果要添加core.keymaps，应当将其放在core.lazy之后
