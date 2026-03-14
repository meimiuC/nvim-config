-- ~/.config/nvim/lua/plugins/blink.lua

return {
  'saghen/blink.cmp',

  -- 使用预编译的二进制版本，避免在本机编译 Rust 源码
  -- '*' 表示自动匹配最新的 release 版本
  -- 如果改成 false，则需要手动 build = 'cargo build --release'
  version = '*',

  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {

    -- ================================================================
    -- 按键映射
    -- ================================================================
    keymap = {
      -- 使用内置预设方案，可选值：
      --   'default'  : <C-n>/<C-p> 上下选择，<C-y> 确认，<C-e> 取消
      --   'super-tab': <Tab>/<S-Tab> 上下选择并确认，与 Copilot 有冲突时需注意
      --   'enter'    : <Enter> 确认，<C-n>/<C-p> 上下选择
      --   'none'     : 不设置任何默认键，完全手动指定
      preset = 'default',
    },

    -- ================================================================
    -- 外观
    -- ================================================================
    appearance = {
      -- 以 nvim-cmp 的高亮组作为默认颜色方案
      -- true  : 沿用 nvim-cmp 的配色（适合从 nvim-cmp 迁移过来的用户）
      -- false : 使用 blink.cmp 自己的高亮组
      use_nvim_cmp_as_default = true,

      -- Nerd Font 字形变体，影响补全菜单图标的宽度计算
      --   'mono'  : 单宽字体（Nerd Font Mono），每个图标占 1 格
      --   'normal': 标准宽度（Nerd Font），每个图标占 2 格
      -- 如果图标和文字之间出现错位，尝试切换这个值
      nerd_font_variant = 'mono',
    },

    -- ================================================================
    -- 补全来源
    -- ================================================================
    sources = {
      -- 默认启用的补全来源列表（按优先级从高到低排列）：
      --   'lsp'      : 来自语言服务器 (LSP) 的补全，最精准
      --   'path'     : 文件路径补全（输入 ./ 或 / 时触发）
      --   'snippets' : 代码片段补全（内置 VSCode 格式 snippet）
      --   'buffer'   : 当前所有打开 buffer 里的词语
      --   'cmdline'  : 命令行补全（通常单独在 cmdline 中启用）
      --   'omni'     : 传统的 omnifunc 补全（较少用）
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },

  -- ================================================================
  -- opts_extend
  -- 告诉 lazy.nvim：当多个插件都想往 sources.default 里追加来源时，
  -- 将它们"合并"而不是"覆盖"。
  -- 例如：如果你安装了 blink-cmp-copilot，它可以无缝把 'copilot'
  -- 追加进来，而不需要你手动修改这里的列表。
  -- ================================================================
  opts_extend = { "sources.default" },
}
