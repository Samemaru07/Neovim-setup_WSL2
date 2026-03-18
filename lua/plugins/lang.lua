return {
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_compiler_progname = "nvr"
            vim.g.vimtex_view_method = "general"
            vim.g.vimtex_view_general_viewer = "/home/samemaru/dotfiles/sioyek-wsl.sh"
            vim.g.vimtex_view_general_options = "--forward-search-file @tex --forward-search-line @line @pdf"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                continuous = 1,
                options = {
                    "-pdf",
                    "-lualatex",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "-file-line-error",
                    "-halt-on-error",
                    "-e '$latexmk_use_gzip_synctex = 0'",
                    "-shell-escape",
                },
            }
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

    { "vhda/verilog_systemverilog.vim" },

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
            vim.g.mkdp_open_to_the_world = 0
            vim.g.mkdp_open_ip = "127.0.0.1"
            vim.g.mkdp_browserfunc = "OpenWslBrowser"
            vim.cmd([[
				function! OpenWslBrowser(url)
					execute 'silent !wslview ' . a:url
				endfunction
			]])
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

    { "sophacles/vim-processing" },
}
