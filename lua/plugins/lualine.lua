-- ~/.config/nvim/lua/plugins/lualine.lua

return {
	"nvim-lualine/lualine.nvim",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	event = "VeryLazy",

	opts = {
		options = {
			-- 让 lualine 和你当前的 tokyonight 主题保持统一
			theme = "tokyonight",
			icons_enabled = true,

			-- 改成箭头状分隔符（powerline 风格）
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },

			disabled_filetypes = {
				statusline = { "lazy", "mason", "help" },
				winbar = {},
			},

			always_divide_middle = true,

			-- 保持每个窗口自己的状态栏
			-- 这样 active / inactive 差异更明显
			globalstatus = false,

			refresh = {
				statusline = 300,
				tabline = 300,
				winbar = 300,
			},
		},

		-- =====================================================
		-- 当前活动窗口：信息更完整
		-- =====================================================
		sections = {
			lualine_a = {
				{
					"mode",
					-- 只显示模式首字母，更简洁
					fmt = function(str)
						return str:sub(1, 1)
					end,
				},
			},

			lualine_b = {
				"branch",
				"diff",
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					sections = { "error", "warn", "info", "hint" },
					diagnostics_color = {
						error = "DiagnosticError",
						warn = "DiagnosticWarn",
						info = "DiagnosticInfo",
						hint = "DiagnosticHint",
					},
					symbols = {
						error = "E:",
						warn = "W:",
						info = "I:",
						hint = "H:",
					},
					colored = true,
					update_in_insert = false,
					always_visible = false,
				},
			},

			lualine_c = {
				-- 现在把阈值调低：
				-- 很窄：只显示文件名
				{
					"filename",
					path = 0,
					shorting_target = 30,
					symbols = {
						modified = " [+]",
						readonly = " [-]",
						unnamed = "[No Name]",
						newfile = "[New]",
					},
					cond = function()
						return vim.fn.winwidth(0) < 40
					end,
				},

				-- 中等宽度：显示相对路径
				{
					"filename",
					path = 1,
					shorting_target = 40,
					symbols = {
						modified = " [+]",
						readonly = " [-]",
						unnamed = "[No Name]",
						newfile = "[New]",
					},
					cond = function()
						local w = vim.fn.winwidth(0)
						return w >= 40 and w < 77
					end,
				},

				-- 稍宽一些：显示更长的路径
				{
					"filename",
					path = 3,
					shorting_target = 50,
					symbols = {
						modified = " [+]",
						readonly = " [-]",
						unnamed = "[No Name]",
						newfile = "[New]",
					},
					cond = function()
						return vim.fn.winwidth(0) >= 77
					end,
				},
			},

			-- 右侧保持简洁
			lualine_x = {
				"filetype",
			},

			lualine_y = { "progress" },
			lualine_z = { "location" },
		},

		-- =====================================================
		-- 非活动窗口：更安静，只保留必要信息
		-- =====================================================
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},

			lualine_c = {
				-- 非活动窗口更容易变窄，所以阈值也一起调低
				{
					"filename",
					path = 0,
					shorting_target = 25,
					symbols = {
						modified = " [+]",
						readonly = " [-]",
						unnamed = "[No Name]",
						newfile = "[New]",
					},
					cond = function()
						return vim.fn.winwidth(0) < 85
					end,
				},
				{
					"filename",
					path = 1,
					shorting_target = 35,
					symbols = {
						modified = " [+]",
						readonly = " [-]",
						unnamed = "[No Name]",
						newfile = "[New]",
					},
					cond = function()
						return vim.fn.winwidth(0) >= 85
					end,
				},
			},

			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},

		tabline = {},
		winbar = {},
		inactive_winbar = {},

		extensions = {
			"lazy",
			"mason",
		},
	},
}
