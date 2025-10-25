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
        "gopls",
    },
})

local on_attach = function(client, bufnr)
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true, buffer = bufnr }

    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

    map("n", "[d", vim.diagnostic.goto_prev, opts)
    map("n", "]d", vim.diagnostic.goto_next, opts)
    map("n", "<leader>dl", vim.diagnostic.open_float, opts)

    if client.name == "tsserver" then
        map(
            "n",
            "<leader>oi",
            ":OrganizeImports<CR>",
            { noremap = true, silent = true, buffer = bufnr, desc = "Organize Imports" }
        )
    end
end

-- capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = vim.lsp.config

-- tsserver 以外の言語サーバ
for _, server in ipairs({ "clangd", "lua_ls", "pyright", "html", "cssls", "jsonls", "svls", "gopls" }) do
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
