-- ~/.config/nvim/lua/plugins/copilot-chat.lua

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	-- 依赖项：底层的 copilot.lua 以及处理异步操作的 plenary
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
	-- 在 Arch Linux 环境下，自动编译 tiktoken 以实现极速、精确的 token 计算
	build = "make tiktoken",

	opts = {
		-- 将常用内置命令的默认英文提示词改为中文，让 AI 默认用中文回复
		prompts = {
			Explain = {
				prompt = "/COPILOT_EXPLAIN 请详细解释这段代码的逻辑和工作原理。",
			},
			Review = {
				prompt = "/COPILOT_REVIEW 请审查这段代码，找出潜在的 bug 并提供优化建议。",
			},
			Optimize = {
				prompt = "/COPILOT_OPTIMIZE 请优化这段代码，提升其性能或可读性。",
			},
			Docs = {
				prompt = "/COPILOT_GENERATE 请为这段代码生成规范的文档注释。",
			},
			FixDiagnostic = {
				prompt = "/COPILOT_FIX 请帮我修复文件中的诊断报错 (Diagnostics)。",
			},
		},

		-- 聊天窗口的 UI 行为
		window = {
			layout = "horizontal", -- 以浮动窗口形式居中弹出
			-- width = 0.8, -- 占据屏幕 80% 宽度
			-- width = 1, -- 占据屏幕 80% 宽度
			-- height = 0.8, -- 占据屏幕 80% 高度
			height = 0.3, -- 占据屏幕 80% 高度
			border = "rounded", -- 圆角边框，与主题保持统一
		},
	},
	-- ======== 新增：覆盖默认的按键映射 ========
	mappings = {
		submit_prompt = {
			normal = "<CR>", -- 普通模式下：按回车键发送
			insert = "<M-s>", -- 插入模式下：按 Alt + s 发送 (M 代表 Meta/Alt)
		},
		close = {
			normal = "q", -- 普通模式下：按 q 关闭聊天窗口
			insert = "<C-c>", -- 插入模式下：按 Ctrl + c 关闭
		},
		reset = {
			normal = "<C-l>", -- 清空当前聊天记录
			insert = "<C-l>",
		},
	},
	-- ===========================================

	-- 快捷键配置（绑定在普通模式 n 和可视模式 v 下均可生效）
	-- 这里我们使用 <leader>a 作为 "AI" 的专属前缀
	keys = {
		{ "<leader>ac", "<cmd>CopilotChatToggle<cr>", desc = "切换聊天窗口", mode = { "n", "v" } },
		-- { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "AI 解释代码", mode = { "n", "v" } },
		-- { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "AI 审查代码", mode = { "n", "v" } },
		-- { "<leader>ao", "<cmd>CopilotChatOptimize<cr>", desc = "AI 优化代码", mode = { "n", "v" } },
		-- { "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "AI 生成注释", mode = { "n", "v" } },
		--
	},
}
