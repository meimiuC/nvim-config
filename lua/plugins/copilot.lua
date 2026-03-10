-- ~/.config/nvim/lua/plugins/copilot.lua

return {
	"zbirenbaum/copilot.lua",
	-- 只有在进入插入模式（开始打字）时才加载，极致优化启动速度
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			-- 核心功能：内联建议 (Ghost Text)
			suggestion = {
				enabled = true,
				auto_trigger = true, -- 自动弹出灰色代码建议
				hide_during_completion = true, -- 当 blink.cmp 补全菜单打开时，暂时隐藏 copilot，避免视觉冲突
				debounce = 75, -- 延迟 75ms 请求，节省资源
				keymap = {
					-- <M-l> 代表 Alt + l (字母 L 的小写)。因为 l 在 Vim 里是向右移动，有“接受并向右推进”的直觉
					accept = "<M-l>",
					-- 逐词接受（当你不想接受整段代码，只想接受下一个单词时）
					accept_word = "<M-w>",
					-- 逐行接受
					accept_line = "<M-j>",
					-- 换下一个建议 / 上一个建议
					next = "<M-]>",
					prev = "<M-[>",
					-- 放弃当前建议
					dismiss = "<C-]>",
				},
			},
			-- 面板功能：在分屏中显示多个建议（通常较少使用，保持默认禁用或按需开启）
			panel = {
				enabled = true,
			},
			-- 文件类型过滤：在哪些文件中禁用 Copilot
			filetypes = {
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				-- 默认允许其他所有类型 (如 cpp, python, lua)
				["."] = true,
			},
		})
	end,
}
