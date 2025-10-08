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
        "sqls"
    }
})

local on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(c)
                    return c.name == "null-ls"
                end
            })
        end
    })
end

-- capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = vim.lsp.config

-- tsserver 以外の言語サーバをループで設定
for _, server in ipairs({ "clangd", "lua_ls", "pyright", "html", "cssls", "jsonls" }) do
    lspconfig(server, {
        on_attach = on_attach,
        capabilities = capabilities
    })
end

-- tsserver の設定を個別に行う
lspconfig("tsserver", {
    on_attach = on_attach,
    capabilities = capabilities,
    -- TSX/JSXファイルをtypescriptreactとして認識させる
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }
})

-- sqls(フォーマット無効化)
lspconfig("sqls", {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    capabilities = capabilities
})
