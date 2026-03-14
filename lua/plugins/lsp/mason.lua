-- ~/.config/nvim/lua/plugins/mason.lua

-- 你要启用 / 安装的 LSP “配置名”
-- 注意：这里写的是 nvim-lspconfig 里的名字，不是 Mason 包名
local servers = { "lua_ls", "clangd", "pyright", "marksman" }

-- 你要通过 Mason 自动安装的“通用工具”
-- 这里主要放 formatter；这些名字写 Mason 包名
local tools = { "clang-format", "stylua", "black" }

return {
    -- 1) Mason：负责下载和管理外部工具
    {
        "mason-org/mason.nvim",
        lazy = false,
        opts = {},
    },

    -- 2) mason-lspconfig：负责“确保这些 LSP 已安装”
    {
        "mason-org/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            ensure_installed = servers,
            automatic_enable = false,
        },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
    },

    -- 3) mason-tool-installer：负责“确保 formatter 等工具已安装”
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        lazy = false,
        opts = {
            run_on_start = true,
            auto_update = false,
            ensure_installed = tools,
        },
        dependencies = {
            "mason-org/mason.nvim",
        },
    },

    -- 4) nvim-lspconfig：负责具体配置与启用
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "saghen/blink.cmp",
        },
        config = function()
            -- 给所有 LSP 统一添加 blink.cmp 的补全能力
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            -- 单独配置 lua_ls
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            -- LSP attach 到当前 buffer 时，再设置 buffer-local 按键
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("my_lsp_attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        vim.keymap.set(mode or "n", keys, func, {
                            buffer = event.buf,
                            desc = "LSP: " .. desc,
                        })
                    end

                    -- 常用跳转 / 查看
                    map("gd", vim.lsp.buf.definition, "跳转到定义")
                    map("gr", vim.lsp.buf.references, "查看引用")
                    map("gI", vim.lsp.buf.implementation, "跳转到实现")
                    map("K", vim.lsp.buf.hover, "悬停文档")

                    -- 重构 / 操作
                    map("<leader>rn", vim.lsp.buf.rename, "重命名")
                    map("<leader>ca", vim.lsp.buf.code_action, "代码操作", { "n", "x" })

                    -- 诊断相关
                    map("<leader>d", vim.diagnostic.open_float, "显示诊断浮窗")
                    map("[d", vim.diagnostic.goto_prev, "跳到上一个诊断")
                    map("]d", vim.diagnostic.goto_next, "跳到下一个诊断")
                    map("<leader>q", vim.diagnostic.setloclist, "把诊断放进 location list")
                end,
            })

            -- 统一诊断显示风格
            vim.diagnostic.config({
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                virtual_text = {
                    spacing = 2,
                    source = "if_many",
                },
                float = {
                    border = "rounded",
                },
            })

            -- 最后再手动启用这些 LSP
            for _, server in ipairs(servers) do
                vim.lsp.enable(server)
            end
        end,
    },
}
