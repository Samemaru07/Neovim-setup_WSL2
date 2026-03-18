return {
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
            vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, opts)
            vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, opts)
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
                    json = { "prettier" },
                    jsonc = { "prettier" },
                    qml = { "qmlformat" },
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
                    prettier = {
                        prepend_args = { "--trailing-comma", "none", "--tab-width", "4" },
                    },
                    stylua = {
                        prepend_args = { "--config-path", vim.fn.stdpath("config") .. "/stylua.toml" },
                    },
                },
            })
        end,
    },

    { "mfussenegger/nvim-lint" },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
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
                adapters = {},
            })
        end,
    },
}
