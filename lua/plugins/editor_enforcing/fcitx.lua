-- ~/.config/nvim/lua/plugins/editor/fcitx.lua

return {
	"h-hg/fcitx.nvim",

	-- 延迟加载：只有当你第一次进入插入模式 (Insert Mode) 时才唤醒这个插件
	-- 这样可以保证 Neovim 的启动速度依然是 0 毫秒级别的
	event = "InsertEnter",

	-- 因为你已经确定只在 Linux 下使用，我们直接去掉所有操作系统判断的累赘代码
	config = function()
		-- 该插件默认会在后台自动接管 InsertLeave 和 InsertEnter 事件
		-- 核心逻辑：
		-- 1. 退出编辑模式 (Esc) -> 自动执行 `fcitx5-remote -c` (强制英文)
		-- 2. 再次进入编辑模式 (i/a/o) -> 自动恢复你退出前的状态 (中文/英文)

		-- 通常情况下这里留空即可，但如果你发现偶尔卡顿，
		-- 可以显式调用它的 setup (默认无需调用)
	end,
}
