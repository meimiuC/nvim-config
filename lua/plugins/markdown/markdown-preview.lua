-- -- ~/.config/nvim/lua/plugins/markdown-preview.lua
--
-- return {
--     "iamcco/markdown-preview.nvim",
--     cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--     ft = { "markdown" },
--
--     build = function()
--         require("lazy").load({ plugins = { "markdown-preview.nvim" } })
--         vim.fn["mkdp#util#install"]()
--     end,
--
--     keys = {
--         {
--             "<leader>mp",
--             function()
--                 -- 【兼容性优化】：判断当前是否在 render-markdown 的影子缓冲区里
--                 -- 如果是，强行跳回左侧的真实源码区，防止浏览器读取虚假数据失败
--                 local is_shadow = pcall(vim.api.nvim_buf_get_var, 0, "mkdp_disable_shadow")
--                 if is_shadow then
--                     vim.cmd("wincmd h")
--                     vim.notify("已自动切换回主文件以启动浏览器预览", vim.log.levels.INFO)
--                 end
--                 -- 然后再安全地启动浏览器预览
--                 vim.cmd("MarkdownPreviewToggle")
--             end,
--             desc = "切换浏览器 Markdown 实时预览",
--         },
--     },
--
--     config = function()
--         vim.cmd([[do FileType]])
--
--         -- 打开 Markdown 文件时是否自动启动浏览器预览
--         -- 0 : 不自动启动，需要手动执行 :MarkdownPreview 或按快捷键
--         -- 1 : 只要打开 .md 文件就立刻弹出浏览器（容易打扰日常浏览，不推荐）
--         vim.g.mkdp_auto_start = 0
--
--         -- 切换到其他 buffer 时是否自动关闭预览窗口
--         -- 0 : 保持浏览器窗口，即使你去编辑其他文件（适合对照参考）
--         -- 1 : 离开当前 Markdown 文件后自动关闭，保持浏览器整洁（推荐）
--         vim.g.mkdp_auto_close = 1
--
--         -- 【兼容性优化】：关闭慢速刷新，将所有的同步工作完全交给底层的 WebSocket 流
--         -- 这能极大减少与终端渲染器抢夺系统 IO 资源的概率
--         -- 0 : 正常速度刷新，每次按键后立即推送更新（配合 WebSocket 流畅）
--         -- 1 : 慢速刷新，只有在"停止输入"一段时间后才刷新（节省性能，但有延迟感）
--         vim.g.mkdp_refresh_slow = 0
--
--         -- 启动预览后是否把服务器 URL 打印到底部命令行
--         -- 0 : 静默启动，不显示 URL
--         -- 1 : 在命令行回显 URL（如 http://127.0.0.1:8080），便于手动复制到其他浏览器
--         vim.g.mkdp_echo_preview_url = 1
--
--         -- 预览页面的配色主题
--         -- "light" : 白底浅色主题（适合白天 / 打印导出）
--         -- "dark"  : 深色主题（与 Neovim 的 tokyonight 风格更统一）
--         vim.g.mkdp_theme = "light"
--
--         -- Firefox 启动行为定义：自定义浏览器打开方式
--         -- 这里覆盖了默认的"在已有窗口中打开新标签"行为，
--         -- 改为每次都用 --new-window 参数打开一个独立窗口，避免混入其他标签页
--         vim.cmd([[
--             function! OpenMarkdownPreview(url)
--                 execute "silent ! firefox --new-window " . a:url
--             endfunction
--         ]])
--         -- mkdp_browserfunc：指定上面定义的 VimScript 函数名作为浏览器启动回调
--         -- 如果想换回系统默认浏览器，将此变量设为 "" 即可
--         vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
--     end,
-- }

-- ~/.config/nvim/lua/plugins/markdown-preview.lua

return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },

	-- 【修复 1：修正构建脚本】
	-- 移除了原配置中的 `require("lazy").load`。
	-- 在 lazy.nvim 的 build 阶段加载自身会导致循环依赖，从而让底层的 Node.js 服务端根本没有成功编译。
	build = function()
		vim.fn["mkdp#util#install"]()
	end,

	keys = {
		{
			"<leader>mp",
			function()
				-- 【保留原有功能】：影子缓冲区兼容
				local is_shadow = pcall(vim.api.nvim_buf_get_var, 0, "mkdp_disable_shadow")
				if is_shadow then
					vim.cmd("wincmd h")
					vim.notify("已自动切换回主文件以启动浏览器预览", vim.log.levels.INFO)
				end
				vim.cmd("MarkdownPreviewToggle")
			end,
			desc = "切换浏览器 Markdown 实时预览",
		},
	},

	config = function()
		vim.cmd([[do FileType]])

		-- 【修复 2：固定端口】
		-- 增加固定端口设定，防止 Arch Linux 随机分配高位端口时被本地策略拦截或与其他开发服务冲突
		vim.g.mkdp_port = "8080"

		-- 【保留原有功能】：行为与主题控制
		vim.g.mkdp_auto_start = 0
		vim.g.mkdp_auto_close = 1
		vim.g.mkdp_refresh_slow = 0
		vim.g.mkdp_echo_preview_url = 1
		vim.g.mkdp_theme = "light"

		-- 【修复 3：修正浏览器异步调用】
		-- 原配置中的 `execute "silent ! firefox ..."` 在 Linux/Wayland 下会阻塞 Neovim 的主线程，
		-- 甚至因为脱离了终端环境变量而启动失败。
		-- 现改为 Neovim 原生的 `jobstart` 异步非阻塞调用，完美保留 `--new-window` 行为。
		vim.cmd([[
            function! OpenMarkdownPreview(url)
                call jobstart(['firefox', '--new-window', a:url])
            endfunction
        ]])

		vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
	end,
}
