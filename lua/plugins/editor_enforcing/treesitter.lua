return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		local ts = require("nvim-treesitter")

		ts.setup({})

		ts.install({
			"markdown",
			"markdown_inline",
			"c",
			"cpp",
			"lua",
			"python",
			"json",
			"bash",
			"vim",
			"vimdoc",
			"query",
		})

		vim.treesitter.language.register("bash", { "sh", "shell", "zsh" })
		vim.treesitter.language.register("python", { "py" })
		vim.treesitter.language.register("cpp", { "c++" })

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("my_treesitter_start", { clear = true }),
			pattern = {
				"c",
				"cpp",
				"lua",
				"python",
				"json",
				"bash",
				"vim",
				"help",
				"markdown",
			},
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
