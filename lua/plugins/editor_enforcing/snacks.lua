-- ~/.config/nvim/lua/plugins/editor_enforcing/snacks.lua

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    opts = {
        -- ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳
        -- ┃ 1. 视觉与 UI 模块 (UI & Visuals)                            ┃
        -- ┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻
        image = {
            enabled = true,
            doc = { enabled = true, inline = false, max_width = 40 },
            formats = {
                "png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff",
                "heic", "avif", "mp4", "mov", "avi", "mkv", "webm", "pdf"
            },
        },
        dashboard = {
            enabled = true,
            width = 60,
            preset = {
                header = [[
 ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
 ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
 ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
 ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
 ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
 ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
                ]],
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            sections = {
                { section = "header" },
                { section = "keys",   gap = 1, padding = 1 },
                { section = "startup" },
            },
        },
        scroll = { enabled = true, animate = { duration = { step = 15, total = 250 }, easing = "linear" } },
        indent = {
            enabled = true,
            char = "│",
            scope = { enabled = true, char = "│", underline = false, only_current = false },
            chunk = { enabled = true, char = { corner_top = "╭", corner_bottom = "╰", horizontal = "─", arrow = "─" } },
        },
        statuscolumn = { enabled = true, left = { "mark", "sign" }, right = { "fold", "git" }, folds = { open = false, git_hl = false } },
        zen = { enabled = true, toggles = { dim = false, git_signs = false, diagnostics = false }, show = { statusline = false, tabline = false }, win = { style = "zen" } },
        animate = { enabled = true, duration = 200, easing = "linear", fps = 60 },

        -- ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳
        -- ┃ 2. 核心效率工具 (Core Utilities)                            ┃
        -- ┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻

        -- 【LazyGit 深度整合】
        lazygit = {
            enabled = true,
            -- 以下是你可以修改的参数
            configure = true,                        -- 是否自动为 LazyGit 生成配置文件（同步主题色）
            config = {
                os = { editPreset = "nvim-remote" }, -- 设置在 LazyGit 中回车打开文件的方式
                gui = {
                    -- 你可以在这里直接写 LazyGit 的原生 yaml 配置
                    -- 例如：mouseEvents = false 禁用鼠标
                },
            },
            -- 窗口样式
            win = {
                style = "lazygit", -- 使用内置的悬浮窗样式
            },
        },
        -- 【已修正层级】：这些配置现在正确地位于 opts 内部
        picker = {
            enabled = true,
            ui_select = true,
            layout = { preset = "ivy" },
            formatters = { file = { filename_first = true, truncate = 80 } },
            win = {
                input = {
                    keys = {
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                        ["<C-v>"] = { "edit_vsplit", mode = { "i" } },
                        ["<C-s>"] = { "edit_split", mode = { "i" } },
                        ["<C-q>"] = { "qflist", mode = { "i" } },
                    },
                },
            },
        },

        previewers = {
            git = { native = true },
            file = { max_size = 1024 * 1024, max_line_length = 500 },
        },

        -- 【新增】：启用 Scratch 模块
        scratch = {
            enabled = true,
            name = "SCRATCH",
            ft = "markdown", -- 默认使用 Markdown，方便记事
        },

        -- ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳
        -- ┃ 3. 性能优化 (Performance)                                   ┃
        -- ┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻
        bigfile = { enabled = true },   --
        quickfile = { enabled = true }, --

    },                                  -- ⚠️ opts 在这里闭合，包含以上所有功能开关

    keys = {
        -- UI 快捷键
        { "<leader>g", function() require("snacks").lazygit() end, desc = "打开 LazyGit" },
        { "<leader>zz", function() Snacks.zen() end, desc = "开启/关闭 Zen 禅模式" },
        { "<leader>zm", function() Snacks.zen.zoom() end, desc = "最大化当前分屏" },

        -- Picker 快捷键
        { "<leader>ff", function() Snacks.picker.files() end, desc = "搜索文件 (Files)" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "全局搜索 (Grep)" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "搜索标签页 (Buffers)" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "最近文件 (Recent)" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "搜索配置 (Config)" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "切换项目 (Projects)" },

        -- 【新增】：Scratch 快捷键
        -- 空格 + 点：弹出/隐藏草稿本
        { "<leader>.", function() Snacks.scratch() end, desc = "切换草稿本 (Scratchpad)" },
        -- 空格 + 大写 S：打开历史草稿列表
        { "<leader>S", function() Snacks.scratch.select() end, desc = "查看所有草稿记录" },
    },
}
