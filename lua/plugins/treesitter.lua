-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		local ts = require("nvim-treesitter")

		ts.setup({})

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("my_treesitter_start", { clear = true }),
			pattern = {
				"c",
				"cpp",
				"lua",
				"python",
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
