-- How to write template:
-- 1. use existing Makefile or tasks.json in the project;
-- 2. write personal single_file_build, such as g++ current.cpp -o current for simple files; cmake -S . -B -DCMAKE_BUILD_TYPE=Debug for first time build in Cmake projects; cmake --build -B build --j for Cmake projects after first time build; ctest --test-dir build for Cmake projects with tests; etc;

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = { "ToggleTerm", "TermExec", "TermSelect", "TermNew" },

	keys = {
		{
			"<leader>tt",
			"<cmd>1ToggleTerm direction=horizontal name=shell<CR>",
			desc = "切换底部终端",
		},
		{
			"<leader>tr",
			function()
				if vim.bo.filetype ~= "fortran" then
					vim.notify("当前缓冲区不是 Fortran 文件", vim.log.levels.WARN)
					return
				end

				local file = vim.fn.expand("%:p")
				local exe_name = vim.fn.expand("%:t:r")
				local exe_path = vim.fn.expand("%:p:r")
				local cwd = vim.fn.expand("%:p:h")

				if file == "" or vim.fn.filereadable(file) == 0 then
					vim.notify("当前文件不存在，请先保存当前文件", vim.log.levels.WARN)
					return
				end

				if vim.fn.filereadable(exe_path) == 0 then
					vim.notify("未找到可执行文件，请先构建当前 Fortran 文件", vim.log.levels.WARN)
					return
				end

				-- 如果源文件更新了，但可执行文件还是旧的，先提醒重新构建
				if vim.fn.getftime(file) > vim.fn.getftime(exe_path) then
					vim.notify("源文件比可执行文件新，请先重新构建", vim.log.levels.WARN)
					return
				end

				vim.cmd(
					string.format(
						"2TermExec direction=horizontal go_back=0 dir=%s cmd=%s",
						vim.fn.shellescape(cwd),
						vim.fn.shellescape("./" .. exe_name)
					)
				)
			end,
			desc = "运行当前 Fortran 可执行文件",
		},
	},

	opts = {
		-- 高度改成函数：大屏时更舒服，小屏时也不会太挤
		size = function(term)
			if term.direction == "horizontal" then
				return math.max(10, math.floor(vim.o.lines * 0.25))
			elseif term.direction == "vertical" then
				return math.max(40, math.floor(vim.o.columns * 0.40))
			end
			return 20
		end,

		direction = "horizontal",

		-- 关闭后恢复到 setup 里的 size，而不是记住你上次手工拉伸后的尺寸
		persist_size = false,

		-- 记住上一次是在 terminal mode 还是 normal mode
		persist_mode = true,

		start_in_insert = true,
		insert_mappings = false,
		terminal_mappings = false,

		-- 程序跑完后先保留输出，便于查看结果
		close_on_exit = false,

		-- 不额外给终端加暗色遮罩，保持和当前主题一致
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

				-- 用双 Esc 退出终端输入态，避免单 Esc 干扰某些 TUI 程序
				map("t", "<Esc><Esc>", [[<C-\><C-n>]], term_opts)

				-- 和普通窗口保持一致的移动逻辑
				map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], term_opts)
				map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], term_opts)
				map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], term_opts)
				map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], term_opts)
				map("t", "<C-w>", [[<C-\><C-n><C-w>]], term_opts)
			end,
		})
	end,
}
