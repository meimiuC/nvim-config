return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = { "ToggleTerm", "TermExec", "TermSelect", "TermNew" },

	keys = {
		{
			"<leader>tt",
			"<cmd>1ToggleTerm direction=horizontal size=12<CR>",
			desc = "切换底部终端",
		},
		{
			"<leader>tr",
			function()
				if vim.bo.filetype ~= "fortran" then
					vim.notify("当前缓冲区不是 Fortran 文件", vim.log.levels.WARN)
					return
				end

				local exe_name = vim.fn.expand("%:t:r")
				local exe_path = vim.fn.expand("%:p:r")
				local cwd = vim.fn.expand("%:p:h")

				if exe_name == "" or exe_path == "" then
					vim.notify("当前文件还没有可运行的可执行文件名", vim.log.levels.WARN)
					return
				end

				if vim.fn.filereadable(exe_path) == 0 then
					vim.notify("未找到可执行文件，请先构建当前 Fortran 文件", vim.log.levels.WARN)
					return
				end

				vim.cmd(
					string.format(
						"2TermExec direction=horizontal size=12 go_back=0 dir=%s cmd=%s",
						vim.fn.shellescape(cwd),
						vim.fn.shellescape("./" .. exe_name)
					)
				)
			end,
			desc = "运行当前 Fortran 可执行文件",
		},
	},

	opts = {
		direction = "horizontal",
		size = 12,
		persist_size = false,
		start_in_insert = true,
		insert_mappings = false,
		terminal_mappings = false,
		close_on_exit = false,
		shade_terminals = false,
		auto_scroll = true,
	},

	config = function(_, opts)
		require("toggleterm").setup(opts)

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*toggleterm#*",
			callback = function()
				local map = vim.keymap.set
				local term_opts = { buffer = 0, silent = true }

				map("t", "<Esc>", [[<C-\><C-n>]], term_opts)
				map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], term_opts)
				map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], term_opts)
				map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], term_opts)
				map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], term_opts)
				map("t", "<C-w>", [[<C-\><C-n><C-w>]], term_opts)
			end,
		})
	end,
}
