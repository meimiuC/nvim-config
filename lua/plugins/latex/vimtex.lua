return {
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.vimtex_view_method = "zathura"

			vim.g.vimtex_compiler_method = "latexmk"

			-- 设置默认 LaTeX 引擎为 XeLaTeX
			-- 注意：引擎参数不要放进 vimtex_compiler_latexmk.options
			vim.g.vimtex_compiler_latexmk_engines = {
				_ = "-xelatex",
				pdflatex = "-pdf",
				lualatex = "-lualatex",
				xelatex = "-xelatex",
			}

			vim.g.vimtex_compiler_latexmk = {
				aux_dir = "",
				out_dir = "",
				callback = 1,
				continuous = 1,
				executable = "latexmk",
				options = {
					"-interaction=nonstopmode",
					"-synctex=1",
					"-file-line-error",
				},
			}

			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_syntax_conceal_disable = 1
		end,

		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "tex",
				callback = function(event)
					local opts = function(desc)
						return {
							buffer = event.buf,
							silent = true,
							desc = desc,
						}
					end

					vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<cr>", opts("LaTeX compile"))
					vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<cr>", opts("LaTeX view PDF"))
					vim.keymap.set("n", "<leader>le", "<cmd>VimtexErrors<cr>", opts("LaTeX errors"))
					vim.keymap.set("n", "<leader>lo", "<cmd>VimtexCompileOutput<cr>", opts("LaTeX compiler output"))
					vim.keymap.set("n", "<leader>lk", "<cmd>VimtexClean<cr>", opts("LaTeX clean aux files"))
					vim.keymap.set("n", "<leader>lK", "<cmd>VimtexClean!<cr>", opts("LaTeX clean all generated files"))
					vim.keymap.set("n", "<leader>ls", "<cmd>VimtexStop<cr>", opts("LaTeX stop compiler"))
					vim.keymap.set("n", "<leader>li", "<cmd>VimtexInfo<cr>", opts("LaTeX VimTeX info"))
				end,
			})
		end,
	},
}
