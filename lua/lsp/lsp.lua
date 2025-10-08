-- Mason のセットアップ
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",
        "lua_ls",
        "pyright",
        "html",
        "cssls",
        "tsserver",
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

-- Neovim 0.11+ 新API: vim.lsp.config
local lspconfig = vim.lsp.config

-- Lua LS
lspconfig("lua_ls", {
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
for _, server in ipairs({ "clangd", "pyright", "html", "cssls", "jsonls" }) do
    lspconfig(server, {
        on_attach = on_attach,
        capabilities = capabilities
    })
end

-- tsserver
lspconfig("tsserver", {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    init_options = {
        preferences = {
            includeCompletionsForModuleExports = true,
            includeCompletionsWithInsertText = true
        },
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                languages = { "vue" }
            }
        }
    }
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
