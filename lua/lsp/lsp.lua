-- Mason のセットアップ
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",
        "lua_ls",
        "pyright",
        "html",
        "cssls",
        "ts_ls",
        "jsonls",
        "sqls",
        "texlab",
        "svls",
    },
})

local on_attach = function(client, bufnr) end

-- capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = vim.lsp.config

-- tsserver 以外の言語サーバ
for _, server in ipairs({ "clangd", "lua_ls", "pyright", "html", "cssls", "jsonls", "svls" }) do
    lspconfig(server, {
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

-- tsserver
lspconfig("tsserver", {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    init_options = {
        emmet = {
            includeLanguages = {
                javascript = "javascriptreact",
                typescript = "typescriptreact",
            },
        },
    },
})

-- sqls(フォーマット無効化)
lspconfig("sqls", {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
})
