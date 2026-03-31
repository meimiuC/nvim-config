local overseer = require("overseer")

return {
	name = "C++: build current file",
	desc = "使用 g++ 构建当前 .cpp，并将输出送入 quickfix / diagnostics",
	tags = { overseer.TAG.BUILD },

	-- Only show this template for C++ files
	condition = {
		filetype = { "cpp" },
	},

	builder = function()
		local file = vim.fn.expand("%:p")
		local cwd = vim.fn.expand("%:p:h")
		local exe = vim.fn.expand("%:p:r")

		return {
			cmd = {
				"g++",
				"-std=c++20",
				"-Wall",
				"-Wextra",
				"-g",
				file,
				"-o",
				exe,
			},
			-- Work in current directory of the src file
			cwd = cwd,
			components = {
				-- Replace the older file when compiling a new one
				{ "unique", replace = true },
				-- Send info to quickfix and diagnostics
				{
					"on_output_quickfix",
					open = false,
					open_on_match = true,
					open_on_exit = "failure",
					items_only = true,
					close = true,
					open_height = 8,
					set_diagnostics = true,
				},
				"default",
			},
		}
	end,
}
