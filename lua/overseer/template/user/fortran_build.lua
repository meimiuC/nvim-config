local overseer = require("overseer")

return {
	name = "Fortran: build current file",
	desc = "使用 gfortran 构建当前 .f90，并将输出送入 quickfix",
	tags = { overseer.TAG.BUILD },

	condition = {
		filetype = { "fortran" },
	},

	builder = function()
		local file = vim.fn.expand("%:p")
		local cwd = vim.fn.expand("%:p:h")
		local exe = vim.fn.expand("%:p:r")

		return {
			cmd = {
				"gfortran",
				"-std=f2018",
				"-Wall",
				"-Wextra",
				"-Wimplicit",
				"-fcheck=all",
				file,
				"-o",
				exe,
			},
			cwd = cwd,
			components = {
				{ "unique", replace = true },
				{
					"on_output_quickfix",
					open = true,
					open_height = 8,
					set_diagnostics = true,
				},
				"default",
			},
		}
	end,
}
