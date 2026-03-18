return {
    { "neovim/nvim-lspconfig" },

    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "prettier",
                    "stylua",
                    "latexindent",
                    "cpptools",
                    "debugpy",
                    "delve",
                    "jq",
                    "jsonnetfmt",
                },
            })
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lsp_settings = require("lsp.lsp")
            local capabilities = lsp_settings.capabilities

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require("lsp.lsp").on_attach(client, bufnr)
                end,
            })

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
                    "vhdl_ls",
                    "harper_ls",
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,

                    ["lua_ls"] = function()
                        require("lspconfig").lua_ls.setup({
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = { globals = { "vim" } },
                                },
                            },
                        })
                    end,

                    ["texlab"] = function()
                        require("lspconfig").texlab.setup({
                            capabilities = capabilities,
                            settings = {
                                texlab = {
                                    chktex = { onOpenAndSave = true, onEdit = true },
                                    build = { onSave = false },
                                },
                            },
                        })
                    end,

                    ["harper_ls"] = function()
                        require("lspconfig").harper_ls.setup({
                            capabilities = capabilities,
                            filetypes = {
                                "tex",
                                "latex",
                                "bib",
                                "markdown",
                                "gitcommit",
                                "c",
                                "cpp",
                                "cs",
                                "go",
                                "java",
                                "html",
                                "javascript",
                                "lua",
                                "nix",
                                "python",
                                "ruby",
                                "rust",
                                "swift",
                                "toml",
                                "typescript",
                                "typescriptreact",
                                "haskell",
                                "cmake",
                                "typst",
                                "php",
                                "dart",
                                "clojure",
                                "sh",
                            },
                        })
                    end,

                    ["sqls"] = function()
                        require("lspconfig").sqls.setup({
                            capabilities = capabilities,
                        })
                    end,

                    ["vhdl_ls"] = function()
                        require("lspconfig").vhdl_ls.setup({
                            capabilities = capabilities,
                            cmd = { "vhdl_ls" },
                            filetypes = { "vhdl" },
                            root_dir = require("lspconfig.util").root_pattern(".git", "*.vhdl"),
                        })
                    end,

                    ["tsserver"] = function()
                        require("lspconfig").tsserver.setup({
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
                    end,

                    ["svlangserver"] = function() end,

                    ["verible"] = function()
                        require("lspconfig").verible.setup({
                            capabilities = capabilities,
                        })
                    end,
                },
            })
        end,
    },

    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },

    {
        "Bilal2453/luvit-meta",
        lazy = true,
    },

    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {},
    },
}
