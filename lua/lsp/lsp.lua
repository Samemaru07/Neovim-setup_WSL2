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

    },

})



local on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {

        buffer = bufnr,

        callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
        end,

    })
end



-- Lua LS の設定（新方式）

vim.lsp.config("lua_ls", {

    on_attach = on_attach,

    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {

        Lua = {

            runtime = {

                version = "LuaJIT",

            },

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



-- 起動

vim.lsp.enable("lua_ls")
