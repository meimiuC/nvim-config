-- ~/.config/nvim/lua/plugins/ui/yazi.lua

return {
	"mikavilpas/yazi.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		{
			"<leader>e",
			function()
				-- 从项目根目录打开（当前工作目录）
				vim.notify("Opening yazi from root directory", vim.log.levels.INFO)
				require("yazi").yazi()
			end,
			desc = "文件管理器侧边栏 (Root)",
		},
		-- {
		--     "<leader>E",
		--     function()
		--         -- 从当前文件所在目录打开
		--         vim.notify("Opening yazi from current file directory", vim.log.levels.INFO)
		--         require("yazi").yazi(nil, vim.fn.expand("%:p:h"))
		--     end,
		--     desc = "文件管理器侧边栏 (Current Dir)",
		-- },
	},
	---@type YaziConfig | {}
	opts = {
		-- 指定在 Neovim 中使用专用的 Yazi 配置目录（去除预览的配置）
		-- 这使得在终端中正常使用 yazi 时仍然有预览
		config_home = vim.fn.expand("~/.config/nvim/yazi_config"),
		-- 替代 netrw 打开目录
		open_for_directories = true,
		-- 侧边栏样式浮动窗口配置
		floating_window_scaling_factor = 1,
		-- 浮动窗口边框样式
		yazi_floating_window_border = "none",
		-- 浮动窗口透明度
		yazi_floating_window_winblend = 0,
		-- 浮动窗口 z-index
		yazi_floating_window_zindex = 50,
		-- 高亮相关配置
		highlight_hovered_buffers_in_same_directory = true,
		-- 关闭 yazi 时改变 Neovim 工作目录
		change_neovim_cwd_on_close = false,
		-- 日志级别
		log_level = vim.log.levels.OFF,
		-- 自定义打开文件行为
		open_file_function = function(chosen_file, config, state)
			-- 默认行为：在当前窗口打开文件
			vim.cmd("edit " .. vim.fn.fnameescape(chosen_file))
		end,
		-- 快捷键映射
		keymaps = {
			show_help = "<f1>",
			open_file_in_vertical_split = "<c-v>",
			open_file_in_horizontal_split = "<c-x>",
			open_file_in_tab = "<c-t>",
			grep_in_directory = "<c-s>",
			send_to_quickfix_list = "<c-q>",
			copy_relative_path_to_selected_files = "<c-y>",
		},
		-- 集成配置
		integrations = {
			grep_in_directory = function(directory)
				-- 使用 telescope 进行搜索（如果已安装）
				local ok, telescope = pcall(require, "telescope.builtin")
				if ok then
					telescope.live_grep({ search_dirs = { directory } })
				end
			end,
			grep_in_selected_files = function(selected_files, relative_paths)
				local ok, telescope = pcall(require, "telescope.builtin")
				if ok then
					telescope.live_grep({ search_dirs = selected_files })
				end
			end,
		},
		-- 钩子函数
		hooks = {
			before_opening_window = function(window_options)
				-- 将窗口定位为普通的左侧分割窗口（非浮动，解决与底部状态栏重叠和共存问题）
				window_options.relative = nil
				window_options.row = nil
				window_options.col = nil
				window_options.style = nil
				window_options.border = nil
				window_options.zindex = nil

				window_options.split = "left"
				window_options.width = 35 -- 调整适当的侧边栏宽度
			end,
			yazi_opened = function(preselected_path, buffer, config)
				-- 移除 yazi.nvim 默认的 VimResized 自动命令，防止终端拉伸时重新变为浮动窗口
				local aucmds = vim.api.nvim_get_autocmds({ event = "VimResized", buffer = buffer })
				for _, a in ipairs(aucmds) do
					vim.api.nvim_del_autocmd(a.id)
				end

				-- 【跳转功能优化】：在 Yazi 终端内直接通过快捷键跳转回 Neovim 其他窗口
				-- 最终跳转快捷键：按下 <C-l> 会直接跳到右侧的代码编辑区
				-- 修改快捷键的方法：修改下方的 "<C-l>" 为您想要的按键（例如 "<A-l>" 等）
				vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { buffer = buffer, desc = "跳转到右侧窗口" })
				vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { buffer = buffer, desc = "跳转到左侧窗口" })
			end,
		},
		-- 未来功能
		future_features = {
			use_cwd_file = true,
		},
	},
	-- 禁用 netrw，让 yazi 完全接管目录打开
	init = function()
		vim.g.loaded_netrwPlugin = 1
	end,
}
