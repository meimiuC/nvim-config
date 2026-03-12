# README 
This is the README file of my personal Neovim config used in Arch Linux.
Containing old but useful config files oneday maybe I want to use again.

## Old Versions
These are config files that have not been used.
However, they are still useful sometimes, so I copy them here.
### render-markdown.lua
This version of render-markdown.lua allows user to read markdown directly in normal version in Neovim like Typora. 
However, this lacks the ability to read Latex fomulas.

``` lua
-- ~/.config/nvim/lua/plugins/render-markdown.lua

return {
	"MeanderingProgrammer/render-markdown.nvim",

	-- 依赖项：需要 treesitter 提供语法解析，需要 devicons 提供各种语言的小图标
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},

	-- 只有在打开 markdown 文件时才加载，绝不拖慢你写 C++ 或 Python 时的启动速度
	ft = { "markdown" },

	opts = {
		-- 核心机制：让插件自动管理 Neovim 的“隐藏级别 (conceallevel)”
		-- 当光标离开这一行时，隐藏 markdown 标记；光标移上去时，显示标记方便编辑
		anti_conceal = {
			enabled = true,
		},

		-- 1. 标题设置
		heading = {
			enabled = true,
			sign = true, -- 在左侧行号旁边也显示一个标志，方便定位
			-- 从 H1 到 H6 替换 `#` 的精美图标
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			-- 开启标题背景色（配合 Tokyonight 主题极其漂亮）
			backgrounds = {
				"RenderMarkdownH1Bg",
				"RenderMarkdownH2Bg",
				"RenderMarkdownH3Bg",
				"RenderMarkdownH4Bg",
				"RenderMarkdownH5Bg",
				"RenderMarkdownH6Bg",
			},
		},

		-- 2. 列表设置 (根据缩进深度切换不同图标)
		bullet = {
			enabled = true,
			icons = { "●", "○", "◆", "◇" },
			left_pad = 1, -- 列表项左侧加一点间距，看起来不拥挤
			right_pad = 1,
		},

		-- 3. 任务复选框
		checkbox = {
			enabled = true,
			unchecked = { icon = "󰄱 " }, -- 未完成: 空心方框
			checked = { icon = "󰱒 " }, -- 已完成: 打钩方框
			-- 甚至支持特殊的进行中状态 `[-]`
			custom = {
				todo = { raw = "[-]", rendered = "󰔟 ", highlight = "RenderMarkdownWarn" },
			},
		},

		-- 4. 代码块
		code = {
			enabled = true,
			sign = true,
			style = "full", -- 开启背景块模式，代码会被包裹在一个带有底色的区块里
			position = "left", -- 语言名称显示在左上方
			language_pad = 2, -- 语言名称左右留白
			disable_background = { "inline" }, -- 行内代码(用单反引号包裹的)不加突兀的背景色
		},

		-- 5. 表格
		table = {
			enabled = true,
			style = "full", -- 用连续的线条画出完整的表格边框
			cell_pad = 1, -- 单元格内容与边框的距离
		},

		-- 6. 引用区块
		quote = {
			enabled = true,
			icon = "▋", -- 将 `>` 替换为左侧粗竖线
			repeat_linebreak = true,
		},
	},
}
```
