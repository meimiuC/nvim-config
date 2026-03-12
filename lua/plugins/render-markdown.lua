-- ~/.config/nvim/lua/plugins/render-markdown.lua

return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown" },

	opts = {
		-- 【修改点 1】：彻底关闭 anti_conceal，并在加载时强制 Neovim 展现所有原始字符
		anti_conceal = { enabled = false },
		on_attach = function()
			-- 强制当前窗口的隐藏级别为 0（即绝不隐藏任何 markdown 原始语法标记）
			vim.opt_local.conceallevel = 0
		end,

		-- 【修改点 2】：保留标题背景色，但移除替换图标
		heading = {
			enabled = true,
			sign = true, -- 在左侧行号旁边显示一个色块标志
			icons = {}, -- 清空图标替换，让你能清楚看到 ###
			-- 保留精美的背景色，让你在长篇文档中一眼区分章节
			backgrounds = {
				"RenderMarkdownH1Bg",
				"RenderMarkdownH2Bg",
				"RenderMarkdownH3Bg",
				"RenderMarkdownH4Bg",
				"RenderMarkdownH5Bg",
				"RenderMarkdownH6Bg",
			},
		},

		-- 【修改点 3】：关闭所有会破坏“纯文本排版”的视觉欺骗功能
		bullet = { enabled = false }, -- 关闭列表图标替换，显示原始的 - 和 *
		checkbox = { enabled = false }, -- 关闭复选框替换，显示原始的 [ ]
		table = { enabled = false }, -- 关闭表格重绘，显示原始的 |---|
		quote = { enabled = false }, -- 关闭引用竖线，显示原始的 >

		-- 【修改点 4】：保留代码块的背景高亮，但不隐藏 ``` 标记
		code = {
			enabled = true,
			sign = true,
			style = "normal", -- 从 "full" 改为 "normal"，避免画出多余的边框，仅保留基础高亮
			position = "left",
			language_pad = 2,
			disable_background = { "inline" },
		},
	},
}
