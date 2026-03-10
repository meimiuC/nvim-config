-- ~/.config/nvim/lua/plugins/blink.lua

return {
  'saghen/blink.cmp',
  -- 下载预编译版本，避免需要手动安装 Rust 环境
  version = '*', 

  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
  
  opts_extend = { "sources.default" }
}
