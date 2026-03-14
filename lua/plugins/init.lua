-- ~/.config/nvim/lua/plugins/init.lua
--
-- 静态插件模块入口。
--
-- 为什么不用动态扫目录？
--   - 动态扫描（uv.fs_scandir）是每次启动都会执行的同步 I/O，无法被缓存。
--   - fs_scandir 的返回顺序由文件系统决定，不保证稳定，在插件存在隐式
--     依赖时容易引发偶发性问题，且难以排查。
--   - 插件分类目录是手动规划、长期稳定的，不需要运行时自动发现。
--
-- 好处：
--   - 零启动时 I/O 开销。
--   - 加载顺序完全可控、可预期。
--   - 一眼就能看出整个配置由哪些模块组成。
--
-- 新增分类目录时，只需在此处追加一行 { import = "plugins.<目录名>" } 即可。

return {
    -- 主题 / 外观基础（含 lazy=false 插件，需尽早注册）
    { import = "plugins.ui" },

    -- LSP、补全、格式化等编程核心能力
    { import = "plugins.lsp" },
    { import = "plugins.coding" },

    -- 编辑器增强：模糊搜索、语法树、快捷键提示等
    { import = "plugins.editor_enforcing" },

    -- Markdown 预览与渲染（按文件类型懒加载，不影响启动）
    { import = "plugins.markdown" },

    -- AI 辅助编程（Copilot 系列）
    { import = "plugins.vibe_coding" },
}
