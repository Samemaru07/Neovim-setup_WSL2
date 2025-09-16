-- Mason のセットアップ
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",
        "lua_ls",
        "pyright",
        "html",
        "cssls",
        "ts_ls",     -- ts_ls に統一
        "jsonls",
    },
})

-- 共通 on_attach
local on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
        end,
    })
end

-- capabilities の設定
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- lspconfig を使う
local lspconfig = require("lspconfig")

-- Lua LS は特別設定
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
            },
            diagnostics = {
                globals = { "vim" },
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "4",
                },
            },
        },
    },
})

-- その他の言語サーバー（共通設定）
local servers = { "clangd", "pyright", "html", "cssls", "ts_ls", "jsonls" }

for _, server in ipairs(servers) do
    lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end
