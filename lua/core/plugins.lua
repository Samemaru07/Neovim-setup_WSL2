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
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
        end,
    },

    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ensure_installed = {
                    "texlab",
                    "ltex",
                    "sqls",
                    "verible-verilog-format",
                    "gopls",
                    "goimports",
                    "prettier",
                    "ruff",
                    "black",
                    "clang_format",
                    "laravel-pint",
                    "stylua",
                    "shfmt",
                    "latexindent",
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            -- ステップ1で修正した lsp.lua をここで require する
            local lsp_settings = require("lsp.lsp")
            local on_attach = lsp_settings.on_attach
            local capabilities = lsp_settings.capabilities

            require("mason-lspconfig").setup({
                -- ↓ ここを lspconfig の「設定名」に修正しました
                ensure_installed = {
                    "clangd",
                    "lua_ls",
                    "pyright",
                    "html",
                    "cssls",
                    "ts_ls", -- "typescript-language-server" ではなく "tsserver"
                    "jsonls",
                    "sqls",
                    "texlab",
                    "svls",
                    "gopls",
                    "vhdl_ls",
                },
                handlers = {
                    -- ↓ デフォルトハンドラ (個別設定が不要なサーバーはこれでOK)
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            on_attach = on_attach,
                            capabilities = capabilities,
                        })
                    end,

                    -- ↓ 元々あった個別設定をここに集約

                    ["lua_ls"] = function()
                        require("lspconfig").lua_ls.setup({
                            on_attach = on_attach,
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
                            on_attach = function(client, bufnr)
                                client.server_capabilities.documentFormattingProvider = false
                                on_attach(client, bufnr) -- 共通の on_attach も呼ぶ
                            end,
                            capabilities = capabilities,
                            settings = {
                                texlab = {
                                    chktex = { onOpenAndSave = true, onEdit = true },
                                    build = { onSave = false },
                                },
                            },
                        })
                    end,
                    ["sqls"] = function()
                        require("lspconfig").sqls.setup({
                            on_attach = function(client, bufnr)
                                client.server_capabilities.documentFormattingProvider = false
                                client.server_capabilities.documentRangeFormattingProvider = false
                                on_attach(client, bufnr) -- 共通の on_attach も呼ぶ
                            end,
                            capabilities = capabilities,
                        })
                    end,
                    ["vhdl_ls"] = function()
                        require("lspconfig").vhdl_ls.setup({
                            on_attach = on_attach,
                            capabilities = capabilities,
                            cmd = { "vhdl_ls" },
                            filetypes = { "vhdl" },
                            root_dir = require("lspconfig.util").root_pattern(".git", "*.vhdl"),
                        })
                    end,
                    ["tsserver"] = function()
                        require("lspconfig").tsserver.setup({
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
                    end,
                },
            })
        end,
    },
    { "Mofiqul/vscode.nvim" },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "uga-rosa/cmp-skkeleton",
            {
                "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
            },
            "saadparwaiz1/cmp_luasnip",
        },
    },
    { "mattn/emmet-vim" },

    {
        "windwp/nvim-autopairs",
        config = function()
            local autopairs = require("nvim-autopairs")
            autopairs.setup({
                check_ts = true,
                ts_context_for = { "jsx", "tsx" },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true },
                ensure_installed = {
                    "html",
                    "javascript",
                    "typescript",
                    "css",
                    "lua",
                    "vim",
                    "bash",
                    "python",
                    "tsx",
                    "json",
                    "yaml",
                    "markdown",
                    "markdown_inline",
                    "dockerfile",
                    "terraform",
                    "hcl",
                    "toml",
                    "ini",
                    "latex",
                    "go",
                },
            })
        end,
    },

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
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = { file_ignore_patterns = { "node_modules", ".git/" } },
            })
            local builtin = require("telescope.builtin")
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "<leader>f", builtin.current_buffer_fuzzy_find, opts)
            vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
            vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)
            vim.keymap.set("n", "<leader>fw", builtin.grep_string, opts)
            -- 現在のドキュメントのシンボル
            vim.keymap.set("n", "<leader>fs", require("telescope.builtin").lsp_document_symbols, opts)
            -- ワークスペース全体のシンボル
            vim.keymap.set("n", "<leader>fS", require("telescope.builtin").lsp_workspace_symbols, opts)
        end,
    },

    {
        "shellRaining/hlchunk.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("hlchunk").setup({
                chunk = {
                    enable = true,
                    style = { guibg = "#2E2E2E" },
                    exclude_filetypes = { "tex", "latex", "markdown" },
                },
                indent = {
                    enable = true,
                    char = "│",
                    style = { "Indent1", "Indent2", "Indent3", "Indent4", "Indent5", "Indent6" },
                },
                highlight = { "Indent1", "Indent2", "Indent3", "Indent4", "Indent5", "Indent6" },
                exclude_filetypes = { "alpha", "NvimTree", "toggleterm" },
            })
            vim.cmd([[
                highlight Indent1 guifg=#FF8FA1 gui=nocombine
                highlight Indent2 guifg=#FFC27F gui=nocombine
                highlight Indent3 guifg=#62C8C8 gui=nocombine
                highlight Indent4 guifg=#7FD1A8 gui=nocombine
                highlight Indent5 guifg=#A776B7 gui=nocombine
                highlight Indent6 guifg=#FFB84D gui=nocombine
            ]])
        end,
    },

    {
        "goolord/alpha-nvim",
        config = function()
            require("ui.dashboard")
        end,
    },

    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("spectre").setup({
                find_engine = { ["rg"] = { cmd = "rg", args = { "--vimgrep" } } },
            })
        end,
    },

    {
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup({ lspconfig = false })
        end,
    },

    {
        "tpope/vim-dadbod",
        dependencies = { "kristijanhusak/vim-dadbod-ui" },
        config = function()
            vim.g.db_ui_save_location = "~/.config/nvim/db_ui"
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },

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
                            { name = "path" },
                        }),
                    })
                end,
            })
        end,
    },

    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_auto_start = 1
        end,
    },
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    html = { "prettier" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    python = { "ruff", "black" },
                    c = { "clang_format" },
                    cpp = { "clang_format" },
                    php = { "pint" },
                    lua = { "stylua" },
                    sh = { "shfmt" },
                    sql = { "pg_format" },
                    tex = { "latexindent" },
                    bib = { "latexindent" },
                    verilog = { "verible-verilog-format", lsp_fallback = false },
                    go = { "goimports" },
                },
                formatters = {
                    latexindent = {
                        command = "latexindent",
                        timeout_ms = 10000,
                    },
                },
            })
        end,
    },
    {
        "lervag/vimtex",
        lazy = false,
        config = function()
            vim.g.vimtex_compiler_progname = "nvr"
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                continuous = 1,
                options = {
                    "-pdf",
                    "-lualatex",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "-e '$latexmk_use_gzip_synctex = 0'",
                    "-shell-escape",
                },
            }
            vim.g.vimtex_view_zathura_update_view_cb = function(self)
                vim.fn.system("sleep 0.3")
                if self.pid and self.pid > 0 then
                    vim.fn.system("kill -HUP " .. self.pid .. " >/dev/null 2>&1")
                else
                    local user = vim.fn.expand("$USER")
                    vim.fn.system("killall -HUP -u " .. user .. " zathura >/dev/null 2>&1")
                end
            end
        end,
    },

    { "vhda/verilog_systemverilog.vim" },
    { "mfussenegger/nvim-lint" },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    {
        "karb94/neoscroll.nvim",
        opts = {
            animation_time = 300,
            easing_function = "quadratic",
        },
    },

    {
        "gen740/SmoothCursor.nvim",
        config = function()
            require("smoothcursor").setup({
                autostart = true,
                speed = 15,
                fancy = { enable = true, head = { cursor = "▷", texthl = "SmoothCursor" } },
            })
        end,
    },

    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({ background_colour = "#000000" })
            vim.notify = require("notify")
        end,
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        config = function()
            require("noice").setup({
                cmdline = {
                    view = "cmdline_popup",
                    format = {
                        cmdline = { pattern = "^:", icon = "", lang = "vim", title = "コマンド" },
                        search_down = {
                            kind = "search",
                            pattern = "^/",
                            icon = "",
                            lang = "regex",
                            title = "検索",
                        },
                        search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex", title = "検索" },
                    },
                },
                views = {
                    cmdline_popup = {
                        position = { row = "40%", col = "50%" },
                        size = { width = 60, height = "auto" },
                        border = { style = "rounded", title_pos = "left" },
                    },
                },
                lsp = {
                    progress = { enabled = false },
                    message = { enabled = false },
                    hover = { enabled = false },
                    signature = { enabled = false },
                },
                presets = { command_palette = false },
            })
        end,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup({
                plugins = { marks = true, registers = true, spelling = { enabled = true, suggestions = 20 } },
                win = { border = "rounded" },
                icons = { show = false },
            })
        end,
    },
    {
        "vim-skk/skkeleton",
        dependencies = {
            "vim-denops/denops.vim",
            "delphinus/skkeleton_indicator.nvim",
        },
        config = function()
            vim.cmd([[
        call skkeleton#config({
        \ 'globalDictionaries': ['~/.skk/SKK-JISYO.L'],
        \ 'userDictionary': '~/.skkeleton',
        \ 'completionRankFile': '~/.skk/rank.json',
        \ 'eggLikeNewline': v:true,
        \ })
        ]])

            vim.cmd([[
  highlight SkkeletonIndicatorEiji guifg=#000000 guibg=#fffff0
  highlight SkkeletonIndicatorHira guifg=#000000 guibg=#f0fff0
  highlight SkkeletonIndicatorKata guifg=#000000 guibg=#f5fffa
  highlight SkkeletonIndicatorHankata guifg=#000000 guibg=#f0ffff
]])

            require("skkeleton_indicator").setup({
                eijiText = "英数",
                hiraText = "かな",
                kataText = "カタカナ",
                hankataText = "半ｶﾀ",
                hl = {
                    eiji = { fg = "#000000", bg = "#fffff0" },
                    hira = { fg = "#000000", bg = "#f0fff0" },
                    kata = { fg = "#000000", bg = "#e0ffff" },
                    hankata = { fg = "#000000", bg = "#fff8dc" },
                },
            })
        end,
    },
    {
        "Bekaboo/dropbar.nvim",
        url = "git@github.com:Bekaboo/dropbar.nvim.git",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                url = "git@github.com:nvim-telescope/telescope-fzf-native.nvim.git",
                build = "make",
            },
        },
        config = function()
            local dropbar_api = require("dropbar.api")
            vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
            vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
            vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
        end,
    },
    {
        "nvim-flutter/flutter-tools.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim",
        },
        config = false,
    },
    {
        "aidavdw/bibcite.nvim",
        cmd = { "CiteOpen", "CiteInsert", "CitePeek", "CiteNote" },
        keys = {
            -- (キー設定は省略)
        },

        -- optsをテーブルではなく関数で定義する
        opts = function()
            local cwd = vim.fn.getcwd() -- 現在の作業ディレクトリを取得

            -- 1. デフォルト設定
            local config = {
                bibtex_path = "~/Documents/research/references.bib",
                pdf_dir = "~/Documents/research/papers",
                notes_dir = "~/Documents/research/notes",
                text_file_open_mode = "vsplit",
            }

            -- 2. 特定のプロジェクトパスの場合、設定を上書き
            -- string.find() を使って、そのディレクトリ（またはサブディレクトリ）にいるか判定

            -- 例: プロジェクトA の場合
            if string.find(cwd, "/home/samemaru/projects/Project_A") then
                config.bibtex_path = "/home/samemaru/projects/Project_A/references.bib"
                config.pdf_dir = "/home/samemaru/projects/Project_A/pdfs"

            -- 例: プロジェクトB の場合
            elseif string.find(cwd, "/home/samemaru/3rd_year/experiment3/amp_fh") then
                config.bibtex_path = "/home/samemaru/3rd_year/experiment3/amp_fh/ref/references.bib"
                -- notes_dir なども必要なら上書き
            end

            -- 3. 最終的な設定テーブルを返す
            return config
        end,
    },
})
