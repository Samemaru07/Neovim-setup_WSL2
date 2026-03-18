return {
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
				\ 'markerHenkan': '▼',
				\ 'markerHenkanSelect': '▼'
				\ })
			]])

            require("skkeleton_indicator").setup({
                eijiText = "英数",
                hiraText = "かな",
                kataText = "カタカナ",
                hankataText = "半ｶﾀ",
            })

            local function set_skk_indicators()
                vim.api.nvim_set_hl(0, "SkkeletonIndicatorEiji", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
                vim.api.nvim_set_hl(0, "SkkeletonIndicatorHira", { fg = "#1e1e2e", bg = "#a6e3a1", bold = true })
                vim.api.nvim_set_hl(0, "SkkeletonIndicatorKata", { fg = "#1e1e2e", bg = "#f9e2af", bold = true })
                vim.api.nvim_set_hl(0, "SkkeletonIndicatorHankata", { fg = "#1e1e2e", bg = "#cba6f7", bold = true })
            end

            set_skk_indicators()

            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = set_skk_indicators,
            })
        end,
    },
}
