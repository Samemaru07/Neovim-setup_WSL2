require("lazy").setup({
    { "nvim-tree/nvim-tree.lua" },
    { "nvim-tree/nvim-web-devicons" },
    { "akinsho/bufferline.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "akinsho/toggleterm.nvim" },
    { "folke/trouble.nvim" },
    { "neovim/nvim-lspconfig" },

    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ensure_installed = {
                    "texlab",
                    "sqls"
                }
            })
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        handlers = {
            function(server_name)
                require("lspconfig")[server_name].setup({})
            end,
            ["sqls"] = function()
                require("lspconfig").sqls.setup({
                    on_attach = function(client, bufnr)
                        client.server_capabilities.documentFormattingProvider = false
                    end
                })
            end
        }
    },
    { "Mofiqul/vscode.nvim" },

    -- 補完プラグイン群
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            {
                "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
            },
            "saadparwaiz1/cmp_luasnip"
        }
    },
    { "mattn/emmet-vim" },

    -- 自動括弧補完
    {
        "windwp/nvim-autopairs",
        config = function()
            local autopairs = require("nvim-autopairs")
            autopairs.setup({
                check_ts = true,
                ts_context_for = { "jsx", "tsx" }
            })
        end
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true },
                ensure_installed = { "html", "javascript", "typescript", "css", "lua", "vim", "bash", "python", "tsx", "json", "yaml", "markdown", "dockerfile", "terraform", "hcl", "toml", "ini", "latex" }
            })
        end
    },

    -- コメントアウト
    {
        "numToStr/Comment.nvim",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
            require("ts_context_commentstring").setup({})
            require("Comment").setup({
                padding = true,
                sticky = true,
                toggler = { line = "<leader>/" },
                opleader = { line = "<leader>/" },
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
            })
        end
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git/" },
                },
            })

            local builtin = require("telescope.builtin")
            local opts = { noremap = true, silent = true }

            vim.keymap.set("n", "<leader>f", builtin.current_buffer_fuzzy_find, opts)
            vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
            vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
        end
    },

    -- インデントに色付け
    {
        "lukas-reineke/indent-blankline.nvim",
        version = "*",
        event = "BufRead"
    },

    -- ダッシュボード
    {
        "goolord/alpha-nvim",
        config = function()
            require("ui.dashboard")
        end
    },

    -- 置換
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("spectre").setup({
                find_engine = {
                    ["rg"] = {
                        cmd = "rg",
                        args = { "--vimgrep" }
                    }
                }
            })
        end
    },

    -- neodev
    {
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup({
                lspconfig = false
            })
        end
    },

    -- dadbod-ui
    {
        "tpope/vim-dadbod",
        dependencies = {
            "kristijanhusak/vim-dadbod-ui"
        },
        config = function()
            vim.g.db_ui_save_location = "~/.config/nvim/db_ui"
            vim.g.db_ui_use_nerd_fonts = 1
        end
    },

    -- vim-dadbod-completion
    {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = { "tpope/vim-dadbod" },
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "psql" },
                callback = function()
                    local cmp = require("cmp")
                    cmp.setup.buffer({
                        sources = cmp.config.sources({
                            { name = "vim-dadbod-completion" },
                        }, {
                            { name = "buffer" },
                            { name = "path" }
                        })
                    })
                end
            })
        end
    },

    -- iamcco
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_auto_start = 0
        end
    },

    -- フォーマッタ群 (pgFormatter と prettier)
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            local prettier = null_ls.builtins.formatting.prettier
            local pg_format = null_ls.builtins.formatting.pg_format.with({
                command = "/usr/local/bin/pg_format",
                to_stdin = true,
                filetypes = { "sql", "pgsql" },
                extra_args = {
                    "--format", "text",
                    "--no-rcfile",
                    "--keyword-case", "2",
                    "--type-case", "2",
                    "--spaces", "4",
                    "--wrap-after", "1"
                }
            })
            null_ls.setup({
                debug = false,
                sources = {
                    prettier,
                    pg_format
                }
            })
        end
    },
    {
        'lervag/vimtex',
        ft = "tex",
        init = function()
            vim.g.vimtex_compiler_method = 'latexmk'
            vim.g.vimtex_view_method = 'zathura'
            vim.g.vimtex_compiler_latexmk = {
                options = {
                    '-e',
                    '$pdflatex=q/uplatex %O -synctex=1 -interaction=nonstopmode %S/',
                    '-pvc',
                    '-pdf',
                },
            }
            vim.g.vimtex_view_zathura_options = '--synctex-editor-command "nvr --remote +%{line} %{input}"'
        end
    }
})
