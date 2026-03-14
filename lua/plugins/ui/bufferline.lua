-- ~/.config/nvim/lua/plugins/bufferline.lua

return {
	"akinsho/bufferline.nvim",
	-- 指定版本，避免上游 breaking change，* 表示获取最新稳定版
	version = "*",
	-- 依然依赖 web-devicons 提供文件图标
	dependencies = "nvim-tree/nvim-web-devicons",

	-- VeryLazy 延迟加载，不拖慢 Neovim 启动速度
	event = "VeryLazy",

	-- 我们在这里直接定义好用的快捷键
	keys = {
		-- 使用 Shift + h 和 Shift + l 来快速左右切换标签，这符合 Vim 的 hjkl 肌肉记忆
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "上一个标签页 (Buffer)" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "下一个标签页 (Buffer)" },

		-- b 代表 buffer
		{ "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "挑选标签页 (Pick)" },
		{ "<leader>bc", "<cmd>bdelete<cr>", desc = "关闭当前标签页" },
		{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "关闭其他所有标签页" },
		{ "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "关闭右侧所有标签页" },
	},

	opts = {
		options = {
			-- 明确告诉它我们是在管理 buffers，而不是 vim tabs
			mode = "buffers",

			-- UI 风格：可选 "slant" (倾斜), "slope" (斜坡), "icon" (图标), "thick" (粗线)
			-- slant 是最经典的类似现代浏览器的倾斜梯形外观
			separator_style = "slant",

			-- 在标签页上直接显示该文件的错误或警告数量（极度好用！）
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local icon = level:match("error") and " " or " "
				return " " .. icon .. count
			end,

			-- 鼠标支持（因为你在 basic.lua 中开启了 mouse="a"）
			close_command = "bdelete! %d", -- 点击关闭按钮时执行的命令
			right_mouse_command = "bdelete! %d", -- 右键点击标签时直接关闭
			left_mouse_command = "buffer %d", -- 左键点击标签时切换

			-- 最关键的配置：让 bufferline 不要盖住 nvim-tree 的顶部！
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer", -- 在 nvim-tree 上方的空白区域显示的文字
					highlight = "Directory",
					text_align = "center",
				},
			},

			-- 如果只有一个文件打开，是否还要显示那孤零零的一个标签？（这里选 true 保持统一体验）
			always_show_bufferline = true,
		},
	},
}
