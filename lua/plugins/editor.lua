return {
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
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
                ts_context_for = { "jsx", "tsx" },
            })
        end,
    },

    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
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
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    insert = false,
                    insert_line = false,
                },
                surrounds = {
                    ["q"] = {
                        add = { "\u{201C}", "\u{201D}" },
                        find = function()
                            return require("nvim-surround.config").get_selection({ motion = 'a"' })
                        end,
                        delete = '^(")().-(")()$',
                    },
                },
            })
        end,
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
        },
    },

    { "mattn/emmet-vim" },
}
