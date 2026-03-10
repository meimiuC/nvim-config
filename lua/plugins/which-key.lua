-- ~/.config/nvim/lua/plugins/which-key.lua

return {
	"folke/which-key.nvim",

	event = "VeryLazy",

	opts = {
		-- 从默认 classic 改成 modern
		-- 作用：切换成 which-key 内置的另一套更现代的展示预设
		preset = "helix",

		delay = function(ctx)
			return ctx.plugin and 0 or 200
		end,

		-- 只显示带 desc 的映射，减少无意义条目
		filter = function(mapping)
			return mapping.desc and mapping.desc ~= ""
		end,

		spec = {},

		notify = true,

		triggers = {
			{ "<auto>", mode = "nxso" },
		},

		defer = function(ctx)
			return ctx.mode == "V" or ctx.mode == "<C-V>"
		end,

		plugins = {
			-- 这些功能很有用，但会在对应场景下弹出额外列表
			-- 先保留 marks / registers
			marks = true,
			registers = true,

			-- 拼写建议不是高频需求，先关掉，减少额外弹窗干扰
			spelling = {
				enabled = false,
				suggestions = 20,
			},

			presets = {
				operators = true,
				motions = true,
				text_objects = true,
				windows = true,
				nav = true,
				z = true,
				g = true,
			},
		},

		win = {
			no_overlap = true,

			-- 边框保留 rounded，与当前 lualine / tokyonight 风格更统一
			border = "rounded",

			-- 减少留白：从默认 {1, 2} 缩到 {0, 1}
			padding = { 0, 1 },

			-- 去掉标题，进一步压缩高度
			title = false,
			title_pos = "center",

			zindex = 1000,

			bo = {},
			wo = {
				-- 稍微加一点透明感，让它更融入整体主题
				-- 0 完全不透明；你可以按喜好改回 0
				winblend = 8,
			},
		},

		layout = {
			-- 官方默认只有 min=20
			-- 这里同时限制 min / max，让弹窗别铺太宽
			width = { min = 16, max = 32 },

			-- 减少列间距：默认是 3，这里缩成 1
			spacing = 1,
		},

		keys = {
			scroll_down = "<c-d>",
			scroll_up = "<c-u>",
		},

		sort = { "local", "order", "group", "alphanum", "mod" },

		-- 保持默认，不自动展开太多 group
		expand = 0,

		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
			ellipsis = "…",

			-- 关闭映射图标，减少宽度占用
			mappings = false,

			rules = {},
			colors = true,
			keys = {},
		},

		-- 关闭帮助提示和按键回显，进一步压缩内容
		show_help = false,
		show_keys = false,
	},

	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "显示当前 buffer 的按键提示",
		},
	},

	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		wk.add({
			{ "<leader>a", group = "AI 助手 (Copilot)" },
			{ "<leader>b", group = "标签页 (Buffer)" },
			{ "<leader>c", group = "代码" },

			{ "<leader>r", group = "重命名/重构" },
			{ "<leader>f", group = "格式化" },
			{ "<leader>e", group = "诊断浮窗" },
			{ "<leader>q", group = "诊断列表" },

			{ "<leader>s", group = "搜索 (Telescope)" },
			-- 为nvim-tree增加提示
			{ "<leader>t", group = "文件树" },
			{ "g", group = "跳转/查看" },

			{ "[d", desc = "上一个诊断" },
			{ "]d", desc = "下一个诊断" },

			{ "<leader>?", desc = "当前 buffer 按键提示" },
		})
	end,
}
