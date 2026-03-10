-- ~/.config/nvim/lua/plugins/tokyonight.lua

return {
    "folke/tokyonight.nvim",
    lazy = false,    -- 启动时不偷懒，立即加载
    priority = 1000, -- 优先级最高，确保最先加载
    opts = {
        style = "night", -- 这里我们选了storm模式，你可以改为 "storm" 或 "night"
    },
    config = function(_, opts)
        -- 配置插件
        require("tokyonight").setup(opts)
        -- 真正激活主题
        vim.cmd.colorscheme "tokyonight"
    end,
}
