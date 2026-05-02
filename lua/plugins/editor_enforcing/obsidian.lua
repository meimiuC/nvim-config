return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	-- ft = "markdown",
	event = {
		"BufReadPre " .. vim.fn.expand("~/vaults/personal") .. "/*.md",
		"BufNewFile " .. vim.fn.expand("~/vaults/personal") .. "/*.md",
		"BufReadPre " .. vim.fn.expand("~/vaults/personal") .. "/**/*.md",
		"BufNewFile " .. vim.fn.expand("~/vaults/personal") .. "/**/*.md",
	},

	opts = {
		legacy_commands = false,
		workspaces = {
			{
				name = "personal",
				path = "~/vaults/personal",
			},
		},

		notes_subdir = "02 Notes",

		daily_notes = {
			folder = "01 Daily&Plan",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily-notes" },
		},

		new_notes_location = "notes_subdir",

		-- preferred_link_style = "markdown",
		preferred_link_style = "wiki",

		disable_frontmatter = true,
	},
}
