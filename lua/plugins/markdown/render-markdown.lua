-- ~/.config/nvim/lua/plugins/render-markdown.lua

-- 【全局折叠辅助函数】：放在最外层防止重复加载报错
local function pad_to_eol(str)
	local win_width = vim.api.nvim_win_get_width(0)
	local str_width = vim.fn.strdisplaywidth(str)
	local spaces_needed = win_width - str_width
	if spaces_needed > 0 then
		return str .. string.rep(" ", spaces_needed)
	else
		return str
	end
end

local function fold_virt_text(result, start_text, lnum)
	local ns_id = vim.api.nvim_get_namespaces()["render-markdown.nvim"]
	local extmarks = vim.api.nvim_buf_get_extmarks(0, ns_id, { lnum, 0 }, { lnum, 0 }, { details = true })
	local details = extmarks[#extmarks] and extmarks[#extmarks][4] or {}
	local ext_hl_str = details.hl_group

	local captured_highlights = vim.treesitter.get_captures_at_pos(0, lnum, 0)
	local ts_hl_str = captured_highlights[#captured_highlights]
			and ("@" .. captured_highlights[#captured_highlights].capture .. ".markdown")
		or ""

	if ts_hl_str ~= "" then
		local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = ts_hl_str, link = true })
		if ok and hl.link then
			ts_hl_str = hl.link
		end
	end

	local ext_hl = ext_hl_str and vim.api.nvim_get_hl(0, { name = ext_hl_str }) or {}
	local ts_hl = ts_hl_str ~= "" and vim.api.nvim_get_hl(0, { name = ts_hl_str }) or {}

	vim.api.nvim_set_hl(0, "MyMergedHL", { fg = ts_hl.fg, bg = ext_hl.bg })
	vim.api.nvim_set_hl(0, "MyInvertMergeHL", { fg = ext_hl.bg, bg = nil })
	table.insert(result, { pad_to_eol(start_text), "MyMergedHL" })
end

_G.markdown_foldtext = function()
	local start_text = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
	local result = {}
	pcall(fold_virt_text, result, start_text, vim.v.foldstart - 1)
	return result
end

-- ========================================================
-- 插件核心配置开始
-- ========================================================
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown" },

	keys = {
		-- 保留你的原地手动切换按键
		{ "<leader>m1", "<cmd>RenderMarkdown toggle<CR>", desc = "手动开启 Render-Markdown" },
	},

	opts = {

		-- ================================================================
		-- Callout（标注块）配置
		-- ================================================================
		-- Callout 是形如 > [!NOTE] 的引用块语法，常见于 Obsidian / GitHub。
		-- 每个条目的字段含义：
		--   raw       : Markdown 源码中的原始标记文本（用于匹配识别）
		--   rendered  : 在 Neovim 里渲染成的图标 + 显示文字
		--   highlight : 使用的高亮组，控制背景 / 前景色
		--               可选内置组：RenderMarkdownInfo（蓝）/ RenderMarkdownWarn（黄）
		--                           RenderMarkdownError（红）/ RenderMarkdownSuccess（绿）
		--                           RenderMarkdownHint（紫）/ RenderMarkdownQuote（灰）
		--   category  : 来源规范，"obsidian" 为 Obsidian 风格，"github" 为 GitHub 风格
		--               目前仅作标记用途，不影响渲染行为
		callout = {
			-- ── 信息类（蓝色）────────────────────────────────────────────
			abstract = {
				raw = "[!ABSTRACT]",
				rendered = "󰯂 Abstract",
				highlight = "RenderMarkdownInfo",
				category = "obsidian",
			},
			summary = {
				raw = "[!SUMMARY]",
				rendered = "󰯂 Summary",
				highlight = "RenderMarkdownInfo",
				category = "obsidian",
			},
			tldr = { raw = "[!TLDR]", rendered = "󰦩 Tldr", highlight = "RenderMarkdownInfo", category = "obsidian" },
			todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo", category = "obsidian" },
			-- ── 错误类（红色）────────────────────────────────────────────
			failure = {
				raw = "[!FAILURE]",
				rendered = "󰅖 Failure",
				highlight = "RenderMarkdownError",
				category = "obsidian",
			},
			fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError", category = "obsidian" },
			missing = {
				raw = "[!MISSING]",
				rendered = "󰅖 Missing",
				highlight = "RenderMarkdownError",
				category = "obsidian",
			},
			danger = {
				raw = "[!DANGER]",
				rendered = "󱐌 Danger",
				highlight = "RenderMarkdownError",
				category = "obsidian",
			},
			error = {
				raw = "[!ERROR]",
				rendered = "󱐌 Error",
				highlight = "RenderMarkdownError",
				category = "obsidian",
			},
			bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError", category = "obsidian" },
			-- ── 警告类（黄色）────────────────────────────────────────────
			attention = {
				raw = "[!ATTENTION]",
				rendered = "󰀪 Attention",
				highlight = "RenderMarkdownWarn",
				category = "obsidian",
			},
			warning = {
				raw = "[!WARNING]",
				rendered = "󰀪 Warning",
				highlight = "RenderMarkdownWarn",
				category = "github",
			}, -- GitHub 原生支持
			-- ── 引用类（灰色）────────────────────────────────────────────
			quote = {
				raw = "[!QUOTE]",
				rendered = "󱆨 Quote",
				highlight = "RenderMarkdownQuote",
				category = "obsidian",
			},
			cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote", category = "obsidian" },
			-- ── 提示类（紫色）────────────────────────────────────────────
			wip = { raw = "[!WIP]", rendered = "󰦖 WIP", highlight = "RenderMarkdownHint", category = "obsidian" },
			-- ── 成功类（绿色）────────────────────────────────────────────
			done = {
				raw = "[!DONE]",
				rendered = "󰄬 Done",
				highlight = "RenderMarkdownSuccess",
				category = "obsidian",
			},
		},

		-- ================================================================
		-- 符号列（Sign Column）
		-- ================================================================
		-- sign.enabled：是否在左侧符号列（signcolumn）中为 Markdown 元素显示标记
		-- true  : 在符号列显示图标，与 LSP 诊断图标共用同一列，可能造成视觉拥挤
		-- false : 禁用，保持符号列整洁（推荐在已开启 LSP 诊断的环境下使用）
		sign = { enabled = false },

		-- ================================================================
		-- 代码块（Fenced Code Block）渲染
		-- ================================================================
		code = {
			-- enabled = true,
			-- language = true,
			-- -- language_icon = true,
			-- language_name = true,
			-- language_info = true,
			-- width：代码块背景的宽度模式
			--   "block"  : 背景宽度仅覆盖代码内容本身（更精致）
			--   "full"   : 背景延伸至整个窗口宽度（更醒目）
			width = "block",

			-- min_width：代码块背景的最小宽度（字符数）
			-- 即使代码很短，背景也至少有 80 列宽，避免看起来太窄
			min_width = 80,

			-- border：代码块的边框样式
			--   "thin"  : 细线边框（─ │ 等单线字符）
			--   "thick" : 粗线边框
			--   "none"  : 无边框
			border = "thin",

			-- left_pad / right_pad：代码内容与左右边框之间的空格数
			left_pad = 1,
			right_pad = 1,

			-- position：语言标签（如 "lua"、"python"）显示在代码块的位置
			--   "right" : 右上角（不遮挡代码内容）
			--   "left"  : 左上角
			position = "right",

			-- language_icon：是否在语言标签旁显示对应的 Nerd Font 图标（如  lua）
			language_icon = true,

			-- language_name：是否显示语言名称文字（如 "lua"）
			language_name = true,

			-- highlight_inline：行内反引号代码（`like this`）使用的高亮组
			highlight_inline = "RenderMarkdownCodeInfo",
		},

		-- ================================================================
		-- 标题（Heading）渲染
		-- ================================================================
		heading = {
			-- icons：各级标题（H1~H6）前缀图标，按顺序对应 # ~ ######
			-- 每个字符串会被渲染在标题行首，替代原来的 # 号
			-- icons = { "❶ ", "❷ ", "❸ ", "❹ ", "❺ ", "❻ " },
			icons = { "󰼏 ", "󰎨 ", "󰼑 ", "󰎲 ", "󰼓 ", "󰎴 " },

			-- border：是否在标题行上下各画一条装饰性分割线
			-- true  : 画分割线，视觉上更像文档章节
			-- false : 不画，更简洁
			border = true,

			-- render_modes：是否在所有编辑模式（包括插入模式）下都保持渲染
			-- true  : 任何模式下标题都显示为渲染后的样式
			-- false : 只在普通模式下渲染，插入模式下恢复原始 Markdown 文本
			render_modes = false,
		},

		-- ================================================================
		-- 复选框（Checkbox）渲染
		-- ================================================================
		checkbox = {
			-- unchecked：未勾选状态 [ ]
			--   icon            : 渲染图标
			--   highlight       : 图标本身的高亮组
			--   scope_highlight : 整行文字的高亮组（nil 表示不改变行颜色）
			unchecked = {
				icon = "󰄱",
				highlight = "RenderMarkdownCodeFallback",
				scope_highlight = "RenderMarkdownCodeFallback",
			},

			-- checked：已勾选状态 [x]
			checked = {
				icon = "󰄵",
				highlight = "RenderMarkdownUnchecked",
				scope_highlight = "RenderMarkdownUnchecked",
			},

			-- custom：自定义状态，可以扩展出任意多种复选框样式
			-- 格式：{ raw = "源码标记", rendered = "图标", highlight = "高亮组", scope_highlight = "行高亮组" }
			custom = {
				question = {
					raw = "[?]",
					rendered = "󰋗",
					highlight = "RenderMarkdownError",
					scope_highlight = "RenderMarkdownError",
				}, -- 疑问
				todo = {
					raw = "[>]",
					rendered = "󰦖",
					highlight = "RenderMarkdownInfo",
					scope_highlight = "RenderMarkdownInfo",
				}, -- 进行中
				canceled = {
					raw = "[-]",
					rendered = "󰅘",
					highlight = "RenderMarkdownCodeFallback",
					scope_highlight = "@text.strike",
				}, -- 已取消（带删除线）
				important = {
					raw = "[!]",
					rendered = "󰳦",
					highlight = "RenderMarkdownWarn",
					scope_highlight = "RenderMarkdownWarn",
				}, -- 重要
				favorite = {
					raw = "[~]",
					rendered = "󰓎",
					highlight = "RenderMarkdownMath",
					scope_highlight = "RenderMarkdownMath",
				}, -- 收藏
			},
		},

		-- ================================================================
		-- 表格（Pipe Table）渲染
		-- ================================================================
		pipe_table = {
			-- alignment_indicator：表格列对齐行（:---:）渲染成的字符
			alignment_indicator = "─",

			-- border：表格边框字符集，按顺序依次是：
			-- 左上角、顶部T形、右上角、左侧T形、中间十字、右侧T形、左下角、底部T形、右下角、竖线、横线
			border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" },
		},

		-- ================================================================
		-- 链接（Link）渲染
		-- ================================================================
		link = {
			-- wiki：Wiki 链接（[[页面名称]] 格式，常用于 Obsidian）
			--   icon            : 前缀图󰎴 标
			--   highlight       : 图标高亮组
			--   scope_highlight : 整段链接文字的高亮组
			wiki = { icon = "󰌹 ", highlight = "RenderMarkdownWikiLink", scope_highlight = "RenderMarkdownWikiLink" },

			-- image：图片链接（![alt](url)）的前缀图标
			image = "󰏌 ",

			-- custom：根据 URL 中包含的关键词，自动替换成对应平台图标
			--   pattern : 在 URL 中匹配的字符串（支持 Lua 模式匹配）
			--   icon    : 匹配成功时显示的图标
			custom = {
				github = { pattern = "github", icon = "󰊤 " },
				gitlab = { pattern = "gitlab", icon = "󰮠 " },
				youtube = { pattern = "youtube", icon = "󰗃 " },
				cern = { pattern = "cern.ch", icon = "󰏮 " },
			},

			-- hyperlink：普通超链接（[text](url)）的前缀图标
			hyperlink = "󰌹 ",
		},

		-- ================================================================
		-- Anti-Conceal（反隐藏）配置
		-- ================================================================
		-- 默认情况下，光标移到某个元素上时，render-markdown 会临时"撤销渲染"
		-- 让你看到原始 Markdown 源码，方便编辑。
		-- anti_conceal.ignore 可以指定哪些元素即使光标在上面也保持渲染状态：
		--   head_border     : 标题分割线（即使光标在标题行也保留装饰线）
		--   head_background : 标题背景色（即使光标在标题行也保留背景色）
		anti_conceal = {
			ignore = { head_border = true, head_background = true },
		},

		-- ================================================================
		-- 窗口选项（Window Options）
		-- ================================================================
		-- win_options 中的每个字段对应一个 Neovim 窗口选项（:h 选项名）
		-- 格式：{ rendered = "渲染时的值", default = "非渲染时的值" }（default 可省略）
		--
		-- concealcursor：在哪些模式下，光标所在行也保持 conceal 隐藏效果
		--   ""    : 任何模式下光标行都显示原文（最保守）
		--   "n"   : 普通模式下也隐藏
		--   "v"   : 可视模式下也隐藏
		--   "i"   : 插入模式下也隐藏
		--   "c"   : 命令行模式下也隐藏
		--   "vc"  : 可视 + 命令行模式下都隐藏（当前配置：编辑时仍能看到原文）
		win_options = { concealcursor = { rendered = "vc" } },

		-- ================================================================
		-- 补全集成（Completions）
		-- ================================================================
		-- 让补全引擎能够感知 Markdown 语法，提供 callout 标签等内容的自动补全
		--   blink.enabled : 集成 blink.cmp（当前使用的补全插件）
		--   lsp.enabled   : 集成 LSP 补全（如 marksman 提供的链接补全）
		completions = { blink = { enabled = true }, lsp = { enabled = true } },
	},

	-- 绑定你的键盘映射和局部设置
	config = function(_, opts)
		require("render-markdown").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(event)
				local buf = event.buf

				-- 开启 marksman 语言服务器
				pcall(vim.lsp.enable, "marksman")

				-- 基础视图设定

				-- 开启或者关闭自动换行
				-- vim.opt_local.wrap = false
				vim.opt_local.wrap = true
				vim.opt_local.conceallevel = 2
				vim.opt_local.foldtext = "v:lua.markdown_foldtext()"
				vim.opt_local.fillchars = [[eob: ,fold: ,foldopen: ,foldsep: ,foldclose: ]]

				-- 【神级功能】：按 gx 解析并打开光标下的 URL
				vim.keymap.set("n", "gx", function()
					local line = vim.fn.getline(".")
					local cursor_col = vim.fn.col(".")
					local pos = 1
					while pos <= #line do
						local open_bracket = line:find("%[", pos)
						if not open_bracket then
							break
						end
						local close_bracket = line:find("%]", open_bracket + 1)
						if not close_bracket then
							break
						end
						local open_paren = line:find("%(", close_bracket + 1)
						if not open_paren then
							break
						end
						local close_paren = line:find("%)", open_paren + 1)
						if not close_paren then
							break
						end
						if
							(cursor_col >= open_bracket and cursor_col <= close_bracket)
							or (cursor_col >= open_paren and cursor_col <= close_paren)
						then
							local url = line:sub(open_paren + 1, close_paren - 1)
							vim.ui.open(url)
							return
						end
						pos = close_paren + 1
					end
					vim.cmd("normal! gx")
				end, { buffer = buf, desc = "URL opener for markdown" })

				-- 【神级功能】：按 zM 智能折叠二级以上标题
				vim.keymap.set("n", "zM", function()
					vim.cmd("silent update")
					vim.cmd("edit!")
					vim.cmd("normal! zR")

					local function fold_headings_of_level(level)
						vim.cmd("keepjumps normal! gg")
						local total_lines = vim.fn.line("$")
						for line = 1, total_lines do
							local line_content = vim.fn.getline(line)
							if line_content:match("^" .. string.rep("#", level) .. "%s") then
								vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
								local current_foldlevel = vim.fn.foldlevel(line)
								if current_foldlevel > 0 then
									if vim.fn.foldclosed(line) == -1 then
										vim.cmd("normal! za")
									end
								end
							end
						end
					end

					local saved_view = vim.fn.winsaveview()
					for _, level in ipairs({ 6, 5, 4, 3, 2 }) do
						fold_headings_of_level(level)
					end
					vim.cmd("nohlsearch")
					vim.fn.winrestview(saved_view)
					vim.cmd("normal! zz")
				end, { buffer = buf, desc = "[P]Fold all headings level 2 or above" })
			end,
		})
	end,
}
