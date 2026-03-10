-- ~/.config/nvim/lua/plugins/nvim-tree.lua

return {
	"nvim-tree/nvim-tree.lua",
	-- 依赖 nvim-web-devicons 来显示漂亮的图标
	dependencies = { "nvim-tree/nvim-web-devicons" },

	-- 按键映射：只有当你按下 <leader>t 时，才真正加载这个插件，加快启动速度
	keys = {
		{ "<leader>t", "<cmd>NvimTreeToggle<CR>", desc = "切换文件树 (NvimTree)" },
	},

	config = function()
		-- 引入 nvim-tree 模块
		local nvim_tree = require("nvim-tree")

		nvim_tree.setup({
			-- 核心外观与行为配置
			view = {
				width = 30, -- 侧边栏宽度设为 30 列
				side = "left", -- 让文件树固定在左侧
				-- 自动适应文件名长度（可选，如果文件名太长会自动撑宽）
				adaptive_size = false,
			},

			-- 过滤器：控制哪些文件不显示
			filters = {
				dotfiles = false, -- false 表示【显示】 . 开头的隐藏文件（比如 .gitignore, .clang-format）
				custom = { "^.git$" }, -- 强制隐藏庞大的 .git 文件夹，保持视图整洁
			},

			-- Git 状态集成
			git = {
				enable = true, -- 开启 git 状态显示
				ignore = false, -- false 表示即使是被 .gitignore 忽略的文件（如编译生成的 .obj / build 目录）也会在树中显示，方便你查看
			},

			-- 焦点跟随：当你在右侧编辑不同的文件时，左侧文件树会自动展开并定位到该文件
			update_focused_file = {
				enable = true,
				update_root = false,
			},

			-- UI 渲染细节
			renderer = {
				highlight_git = true, -- 让文件名跟随 Git 状态变色（比如新增的是绿色，修改的是黄色）
				icons = {
					show = {
						git = true, -- 显示 git 状态的小图标
						folder = true,
						file = true,
						folder_arrow = true, -- 文件夹前面的小箭头
					},
				},
				-- 缩进辅助线，让你在多层级复杂的项目中（如源代码和头文件嵌套时）也能看清目录结构
				indent_markers = {
					enable = true,
				},
			},
		})
	end,
}
