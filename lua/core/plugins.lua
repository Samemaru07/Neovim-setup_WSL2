require("lazy").setup({
    { "nvim-tree/nvim-tree.lua" },
    { "nvim-tree/nvim-web-devicons" },
    { "akinsho/bufferline.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "akinsho/toggleterm.nvim" },
    { "folke/trouble.nvim" },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            lspconfig.sqls.setup({
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                end
            })
        end
    },

    { "williamboman/mason.nvim" },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        lazy = false
    },
    { "Mofiqul/vscode.nvim" },

    -- 補完
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
    },
    { "rafamadriz/friendly-snippets" },
    { "mattn/emmet-vim" },

    -- フォーマッタ / リンタ
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    -- 自動括弧補完
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                ensure_installed = { "html", "javascript", "typescript", "css", "lua" },
            })
        end,
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
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
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

            -- バッファ内検索（現在開いているファイル）
            vim.keymap.set("n", "<leader>f", builtin.current_buffer_fuzzy_find, opts)
            -- ファイル検索
            vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
            -- バッファ検索（開いているファイル一覧）
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
            -- SQL系ファイルで nvim-cmp に dadbod-completion を追加
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

    -- pgFormatter
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")

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
                debug = true,
                sources = { pg_format }
            })
        end
    }
})
