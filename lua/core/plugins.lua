require("lazy").setup({
    { "nvim-tree/nvim-tree.lua" },
    { "nvim-tree/nvim-web-devicons" },
    { "akinsho/bufferline.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "akinsho/toggleterm.nvim" },
    { "folke/trouble.nvim" },
    {
        "neovim/nvim-lspconfig",
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ensure_installed = {
                    "texlab",
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
                    "harper_ls",
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
                            capabilities = lsp_settings.capabilities,
                        })
                    end,
                },
            })
        end,
    },
    -- { "Mofiqul/vscode.nvim" },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {},
    },
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
                    "c",
                    "cpp",
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
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git/" },
                    mappings = {
                        i = {
                            ["<C-j>"] = false,
                        },
                    },
                },
            })
            local builtin = require("telescope.builtin")
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "<leader>f", builtin.current_buffer_fuzzy_find, opts)
            vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
            vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)
            vim.keymap.set("n", "<leader>fw", builtin.grep_string, opts)
            vim.keymap.set("n", "<leader>fs", require("telescope.builtin").lsp_document_symbols, opts)
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
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_open_to_the_world = 1
            vim.g.mkdp_browserfunc = "OpenWslBrowser"
            vim.cmd([[
            function! OpenWslBrowser(url)
                execute 'silent !wslview ' . a:url
            endfunction
        ]])
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
                    ["verible-verilog-format"] = {
                        command = "/usr/local/bin/verible-verilog-format",
                        args = { "-" },
                    },
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
                    "-bibtex",
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
                autostart = false,
                speed = 15,
                fancy = { enable = true, head = { cursor = "▷", texthl = "SmoothCursor" } },
            })
        end,
    },

    {
        "folke/noice.nvim",
        lazy = false,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })

            require("notify").setup({
                stages = "fade_in_slide_out",
                timeout = 2000,
                fps = 60,
                render = "default",
                icons = {
                    ERROR = "❌",
                    WARN = "⚠️",
                    INFO = "💬",
                    DEBUG = "🐞",
                    TRACE = "🔍",
                },
            })

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
                        search_up = {
                            kind = "search",
                            pattern = "^%?",
                            icon = "",
                            lang = "regex",
                            title = "検索",
                        },
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
                routes = {
                    {
                        filter = { event = "msg_show", kind = "", find = "lines yanked" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", kind = "", find = "line yanked" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", kind = "diagnostic" },
                        opts = { skip = true },
                    },
                },
                messages = {
                    view = "notify",
                    view_error = "notify",
                    view_warn = "notify",
                    view_history = "messages",
                    view_search = "virtualtext",
                },
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
            "NI57721/skkeleton-henkan-highlight",
        },
        config = function()
            vim.cmd([[
        call skkeleton#config({
        \ 'globalDictionaries': ['~/.skk/SKK-JISYO.L'],
        \ 'userDictionary': '~/.skkeleton',
        \ 'completionRankFile': '~/.skk/rank.json',
        \ 'eggLikeNewline': v:true,
        \ 'markerHenkan': '',
        \ 'markerHenkanSelect': ''
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
        config = function()
            require("flutter-tools").setup({
                flutter_path = "/home/samemaru/development/flutter/bin/flutter",
                widget_guides = { enabled = true },
                decorations = { statusline = { device = true } },
                dev_log = { enabled = true, open_cmd = "tabnew" },
                outline = { open_cmd = "30vsplit" },
            })

            vim.api.nvim_create_autocmd("VimEnter", {
                pattern = "*",
                callback = function()
                    local cwd = vim.fn.getcwd()
                    if vim.fn.isdirectory(cwd .. "/lib") == 1 then
                        require("flutter-tools").setup_project()
                    end
                end,
            })
        end,
    },
    {
        "aidavdw/bibcite.nvim",
        cmd = { "CiteOpen", "CiteInsert", "CitePeek", "CiteNote" },
        keys = {},

        opts = function()
            local cwd = vim.fn.getcwd()

            local config = {
                bibtex_path = "~/Documents/research/references.bib",
                pdf_dir = "~/Documents/research/papers",
                notes_dir = "~/Documents/research/notes",
                text_file_open_mode = "vsplit",
            }

            if string.find(cwd, "/home/samemaru/projects/Project_A") then
                config.bibtex_path = "/home/samemaru/projects/Project_A/references.bib"
                config.pdf_dir = "/home/samemaru/projects/Project_A/pdfs"
            elseif string.find(cwd, "/home/samemaru/3rd_year/experiment3/amp_fh") then
                config.bibtex_path = "/home/samemaru/3rd_year/experiment3/amp_fh/ref/references.bib"
            end

            return config
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("treesitter-context").setup({
                enable = true,
                max_lines = 0,
                min_window_height = 0,
                line_numbers = true,
                trim_scope = "outer",
                separator = nil,
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            require("mason-nvim-dap").setup({
                ensure_installed = { "python", "cppdbg", "delve" },
                automatic_installation = true,
                handlers = {},
            })

            dapui.setup()
            require("nvim-dap-virtual-text").setup()

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "DAP Continue" })
        end,
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    -- 言語ごとのアダプターを追加 (例: neotest-python, neotest-go など)
                },
            })
        end,
    },
    {
        "gen740/SmoothCursor.nvim",
        config = function()
            require("smoothcursor").setup({
                autostart = true,
                cursor = "",
                texthl = "SmoothCursor",
                linehl = nil,
                type = "default",
                fancy = {
                    enable = true,
                    head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
                    body = {
                        { cursor = "●", texthl = "SmoothCursorRed" },
                        { cursor = "●", texthl = "SmoothCursorOrange" },
                        { cursor = "●", texthl = "SmoothCursorYellow" },
                        { cursor = "●", texthl = "SmoothCursorGreen" },
                        { cursor = "•", texthl = "SmoothCursorAqua" },
                        { cursor = ".", texthl = "SmoothCursorBlue" },
                        { cursor = ".", texthl = "SmoothCursorPurple" },
                    },
                    tail = { cursor = nil, texthl = "SmoothCursor" },
                },
                flyin_effect = "bottom",
                speed = 25,
                intervals = 35,
                priority = 10,
                timeout = 3000,
                threshold = 3,
                disable_float_win = false,
                enabled_filetypes = nil,
                disabled_filetypes = { "help", "lazy" },
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
})
