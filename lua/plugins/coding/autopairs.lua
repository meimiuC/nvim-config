-- ~/.config/nvim/lua/plugins/autopairs.lua

return {
	"windwp/nvim-autopairs",

	-- 官方 README 推荐给 lazy.nvim 的触发时机：
	-- 进入插入模式时再加载
	event = "InsertEnter",

	-- 用 config 而不是 opts，是因为这次除了 setup(...) 之外，
	-- 我们还要额外 add_rules(...)
	config = function()
		local npairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")

		npairs.setup({
			-- 是否启用 autopairs
			enabled = function(bufnr)
				return true
			end,

			-- 在这些特殊 buffer 中禁用
			-- 这是 README 默认值，保留更稳妥
			disable_filetype = {
				"TelescopePrompt",
				"spectre_panel",
				"snacks_picker_input",
			},

			-- 录制/执行宏时禁用，避免影响宏回放
			disable_in_macro = true,

			-- 可视块模式后进入插入时，不额外禁用
			disable_in_visualblock = false,

			-- Replace 模式中禁用
			disable_in_replace_mode = true,

			-- 如果右边已经跟着某些字符，就不要重复补一对
			-- 这是 README 默认值，不建议现在乱改
			ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],

			-- 当右边已经有配对闭合符号时，输入同符号可直接“穿过去”
			enable_moveright = true,

			-- 在引号之后仍允许继续进行配对判断
			enable_afterquote = true,

			-- 只检查当前行内的括号情况
			enable_check_bracket_line = true,

			-- 在引号里也允许括号配对
			enable_bracket_in_quote = true,

			-- 先不开 abbreviation
			enable_abbr = false,

			-- 把自动配对拆成更自然的 undo 片段
			break_undo = true,

			-- 暂时不开 Treesitter 检查
			-- 因为你现在还没有配置 nvim-treesitter
			check_ts = false,

			-- 在 {|} 中按回车时，自动展开成多行代码块
			map_cr = true,

			-- 智能退格删除成对符号
			map_bs = true,

			-- 暂时不开这两个额外删除映射
			map_c_h = false,
			map_c_w = false,
		})

		-- =========================================================
		-- 自定义规则 1：逗号 / 分号直接穿过
		--
		-- 来自官方 wiki 的 "Move past commas and semicolons"
		-- 作用：
		--   当光标右边已经有 , 或 ; 时，
		--   再输入同样字符，不重复插入，而是直接跳过去
		--
		-- 例子：
		--   foo(a,|)   输入 ,  ->  foo(a,|)
		--   return x;| 输入 ;  ->  return x;|
		-- =========================================================
		for _, punct in pairs({ ",", ";" }) do
			npairs.add_rules({
				Rule("", punct)
					:with_move(function(opts)
						return opts.char == punct
					end)
					:with_pair(function()
						return false
					end)
					:with_del(function()
						return false
					end)
					:with_cr(function()
						return false
					end)
					:use_key(punct),
			})
		end
	end,
}
