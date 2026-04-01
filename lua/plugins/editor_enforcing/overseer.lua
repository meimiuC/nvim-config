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
				local ft = vim.bo.filetype
				local name = vim.api.nvim_buf_get_name(0)

				if name == "" then
					vim.notify("请先保存当前文件，再执行构建", vim.log.levels.WARN)
					return
				end

				if ft == "" then
					vim.notify("当前缓冲区没有 filetype，无法自动匹配构建模板", vim.log.levels.WARN)
					return
				end

				-- 只在文件有修改时保存
				vim.cmd("silent update")

				local overseer = require("overseer")

				overseer.run_task({
					tags = { overseer.TAG.BUILD },
					first = true,
					search_params = {
						filetype = ft,
						dir = vim.fn.expand("%:p:h"),
					},
				}, function(task, err)
					if err then
						vim.notify("构建任务启动失败: " .. err, vim.log.levels.ERROR)
						return
					end

					if not task then
						vim.notify(
							string.format("没有找到适用于 filetype=%s 的 BUILD 模板", ft),
							vim.log.levels.WARN
						)
					end
				end)
			end,
			desc = "构建当前文件",
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
