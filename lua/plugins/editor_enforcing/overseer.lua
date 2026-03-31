return {
	"stevearc/overseer.nvim",
	cmd = {
		"OverseerRun",
		"OverseerToggle",
		"OverseerOpen",
		"OverseerClose",
		"OverseerTaskAction",
		"OverseerShell",
	},

	keys = {
		{
			"<leader>oo",
			"<cmd>OverseerToggle! bottom<CR>",
			desc = "切换 Overseer 任务列表",
		},
		{
			"<leader>or",
			"<cmd>OverseerRun<CR>",
			desc = "选择并运行 Overseer 任务",
		},
		{
			"<leader>ob",
			function()
				if vim.bo.filetype ~= "fortran" then
					vim.notify("当前缓冲区不是 Fortran 文件", vim.log.levels.WARN)
					return
				end

				local name = vim.api.nvim_buf_get_name(0)
				if name == "" then
					vim.notify("请先保存当前文件，再执行构建", vim.log.levels.WARN)
					return
				end

				-- 只在文件有修改时保存
				vim.cmd("silent update")

				-- 直接按模板名运行，比 tags/search_params 更稳定
				require("overseer").run_template({
					name = "Fortran: build current file",
				})
			end,
			desc = "构建当前 Fortran 文件",
		},
	},

	opts = {
		task_list = {
			direction = "bottom",
			min_height = 10,
			max_height = { 20, 0.30 },
			default_detail = 2,
		},
		output = {
			-- 保留最近一次输出，便于回看
			preserve_output = true,
			-- 构建输出不走终端，而是走 quickfix / diagnostics
			use_terminal = false,
		},
	},

	config = function(_, opts)
		local overseer = require("overseer")
		overseer.setup(opts)

		-- 预热当前目录的任务缓存，减少第一次运行模板时的等待
		vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
			callback = function()
				overseer.preload_task_cache({ dir = vim.fn.getcwd() })
			end,
		})
	end,
}
