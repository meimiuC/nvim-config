-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
    "nvim-treesitter/nvim-treesitter",

    -- lazy = false：不延迟加载，Neovim 启动时立刻初始化
    -- 之所以不懒加载，是因为 Treesitter 的语法高亮需要在任何文件打开之前就就位
    -- 否则第一次打开文件时会出现短暂的无高亮闪烁
    lazy = false,

    -- build：插件安装或更新后自动执行的命令
    -- ':TSUpdate' 会将所有已安装的语言 parser 更新到最新版本
    -- 如果不加这行，parser 版本可能与插件版本不匹配，导致报错
    build = ":TSUpdate",

    config = function()
        local ts = require("nvim-treesitter")

        -- setup({}) 使用默认配置初始化 Treesitter
        -- 注意：nvim-treesitter 新版本已将 ensure_installed / highlight 等选项
        -- 移出 setup()，改由 FileType 自动命令 + vim.treesitter.start() 驱动
        -- 所以这里传空表 {} 即可，具体语言在下面的 autocmd 里按需启用
        ts.setup({})

        -- ================================================================
        -- 按文件类型按需启动 Treesitter 解析器
        -- ================================================================
        -- 使用 FileType 自动命令，只在打开特定类型文件时才启动对应 parser
        -- 这比全局 ensure_installed + highlight.enable = true 更精确、更省资源
        vim.api.nvim_create_autocmd("FileType", {

            -- 用具名 augroup 管理，{ clear = true } 确保重新加载配置时不会重复注册
            group = vim.api.nvim_create_augroup("my_treesitter_start", { clear = true }),

            -- 需要启用 Treesitter 的文件类型列表
            -- Treesitter 支持的语言完整列表见：
            -- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
            -- 要添加新语言，直接在这里追加对应的 filetype 字符串即可
            -- 例如：添加 "rust", "go", "typescript", "javascript", "json", "yaml" 等
            pattern = {
                "c",        -- C 语言
                "cpp",      -- C++
                "lua",      -- Lua（配置 Neovim 本身用）
                "python",   -- Python
                "vim",      -- VimScript（.vim 文件 / 内置帮助文档）
                "help",     -- Neovim 内置 :help 文档（vimdoc parser）
                "markdown", -- Markdown（render-markdown.nvim 依赖此 parser）
            },

            callback = function()
                -- pcall 是"保护性调用"：如果当前文件类型没有安装对应 parser，
                -- 它会静默失败，而不会弹出烦人的报错信息
                -- 相当于"有 parser 就用，没有就跳过"
                -- 如果想在缺少 parser 时收到提示，可以改成：
                --   local ok, err = pcall(vim.treesitter.start)
                --   if not ok then vim.notify(err, vim.log.levels.WARN) end
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
