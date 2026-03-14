-- ~/.config/nvim/lua/plugins/tokyonight.lua

return {
    "folke/tokyonight.nvim",

    -- lazy = false：主题必须在启动时立刻加载，否则其他插件还没拿到配色就开始渲染，
    -- 会出现短暂的白屏或颜色错乱
    lazy = false,

    -- priority = 1000：让这个插件比其他所有插件更早加载
    -- 数字越大优先级越高；默认值是 50，设成 1000 确保主题最先就位
    priority = 1000,

    opts = {
        -- 主题风格，可选值：
        --   "storm" : 深蓝灰色背景，对比度适中，最经典的 TokyoNight 外观
        --   "night"  : 比 storm 更深、更暗的背景，适合低光环境长时间写代码
        --   "moon"   : 介于 storm 和 night 之间，带一点暖色调，柔和不刺眼
        --   "day"    : 浅色主题（白底），适合白天强光环境
        style = "night",
    },

    config = function(_, opts)
        -- 将上面的 opts 传入插件进行配置
        require("tokyonight").setup(opts)

        -- 真正激活主题：等价于在 Vim 命令行输入 :colorscheme tokyonight
        vim.cmd.colorscheme("tokyonight")
    end,
}
