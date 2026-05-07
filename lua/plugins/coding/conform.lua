-- ~/.config/nvim/lua/plugins/conform.lua

return {
	"stevearc/conform.nvim",

	-- 打开文件时加载
	event = { "BufReadPre", "BufNewFile" },

	-- 查看 Conform 当前状态的命令
	cmd = { "ConformInfo" },

	-- 即使已经开启“保存时自动格式化”，仍然保留手动格式化按键
	-- 这样你在需要时，仍然可以主动格式化当前文件
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({
					async = true,
					lsp_format = "fallback",
				})
			end,
			desc = "格式化当前文件",
		},
	},

	opts = {
		-- 不同文件类型使用不同 formatter
		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
			lua = { "stylua" },
			python = { "black" },
			tex = { "latexindent" },
			plaintex = { "latexindent" },
		},

		-- 调用 conform.format() 时的默认策略
		default_format_opts = {
			-- 优先使用专用 formatter
			-- 如果当前文件类型没有配置专用 formatter，再退回到 LSP formatting
			lsp_format = "fallback",
		},

		-- 保存时自动格式化
		format_on_save = {
			-- 最多等待 500ms
			-- 这是 conform README 里推荐的示例值
			timeout_ms = 500,

			-- 先用专用 formatter；没有时再回退到 LSP
			lsp_format = "fallback",
		},

		-- 出错时给出提示，便于排查
		notify_on_error = true,

		-- 当前 buffer 没有可用 formatter 时也提示
		notify_no_formatters = true,
	},
}
