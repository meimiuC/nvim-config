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

				vim.cmd("silent write")

				local overseer = require("overseer")
				overseer.run_task({
					tags = { overseer.TAG.BUILD },
					search_params = {
						filetype = "fortran",
						dir = vim.fn.expand("%:p:h"),
					},
					first = true,
				})
			end,
			desc = "构建当前 Fortran 文件",
		},
	},

	opts = {
		task_list = {
			direction = "bottom",
			min_height = 8,
			max_height = { 18, 0.25 },
			default_detail = 1,
		},
		output = {
			preserve_output = false,
			use_terminal = false,
		},
	},

	config = function(_, opts)
		local overseer = require("overseer")
		overseer.setup(opts)

		vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
			callback = function()
				local cwd = (vim.v.cwd ~= "" and vim.v.cwd) or vim.fn.getcwd()
				overseer.preload_task_cache({ dir = cwd })
			end,
		})
	end,
}
