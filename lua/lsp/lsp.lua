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
            vim.lsp.buf.format({ bufnr = bufnr })
        end
    })
end

-- capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- lspconfig
local lspconfig = require("lspconfig")

-- Lua LS
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false
            },
            diagnostics = {
                globals = { "vim" }
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "4"
                }
            }
        }
    }
})

-- その他の言語サーバ
local servers = { "clangd", "pyright", "html", "cssls", "ts_ls", "jsonls", "sqls" }

for _, server in ipairs(servers) do
    lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities
    })
end
