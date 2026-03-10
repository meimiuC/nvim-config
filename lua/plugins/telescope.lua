-- ~/.config/nvim/lua/plugins/telescope.lua

return {
	"nvim-telescope/telescope.nvim",
	-- 推荐使用最新的 0.1 版本分支，保证稳定性
	branch = "0.1.x",
	-- Telescope 强依赖 plenary.nvim 提供异步能力
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},

	keys = {
		-- s 代表 Search (搜索)
		{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "搜索文件 (Find Files)" },
		{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "全局搜索文本 (Live Grep)" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "搜索当前光标下的词" },
		{ "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "搜索已打开的 Buffer" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "搜索帮助文档" },
		{ "<leader>so", "<cmd>Telescope oldfiles<cr>", desc = "搜索最近打开的文件" },
	},

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				-- 提示符前缀
				prompt_prefix = "   ",
				selection_caret = "  ",
				entry_prefix = "  ",

				-- 快捷键映射（仅在 Telescope 弹出窗口中生效）
				mappings = {
					i = {
						-- 在插入模式下，使用 <C-j> 和 <C-k> 上下移动（符合 Vim 习惯）
						-- 默认是 <C-n> 和 <C-p>
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						-- 使用 <C-c> 关闭窗口
						["<C-c>"] = actions.close,
					},
					n = {
						-- 在普通模式下，直接按 q 退出
						["q"] = actions.close,
					},
				},

				-- 文件忽略规则：不搜索庞大的 .git 目录
				file_ignore_patterns = {
					"%.git/",
					"node_modules/",
				},
			},
			pickers = {
				find_files = {
					-- 默认不搜索隐藏文件，保持结果干净
					hidden = false,
				},
				live_grep = {
					-- live_grep 也可以配置一些专属选项，这里先保持默认的强大能力
				},
			},
		})
	end,
}
