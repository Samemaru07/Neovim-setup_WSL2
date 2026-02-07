-- vim.cmd.colorscheme("vscode")
--
-- local function apply_transparency()
--     vim.cmd([[
--     highlight Normal guibg=NONE
--     highlight NormalNC guibg=NONE
--     highlight NonText guibg=NONE
--     highlight EndOfBuffer guibg=NONE
--     highlight SignColumn guibg=NONE
--     highlight NvimTreeNormal guibg=NONE
--     highlight NvimTreeVertSplit guibg=NONE
--     highlight NvimTreeEndOfBuffer guibg=NONE
--     highlight NvimTreeStatusLine guibg=NONE
--     highlight NvimTreeStatusLineNC guibg=NONE
--     highlight NormalFloat guibg=#1E1E1E
--     highlight WhichKeyFloat guibg=NONE
--   ]])
-- end
--
-- vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
--     callback = function()
--         vim.cmd([[
--       highlight IndentRainbow1 guifg=#E06C75 gui=nocombine
--       highlight IndentRainbow2 guifg=#E5C07B gui=nocombine
--       highlight IndentRainbow3 guifg=#98C379 gui=nocombine
--       highlight IndentRainbow4 guifg=#56B6C2 gui=nocombine
--       highlight IndentRainbow5 guifg=#61AFEF gui=nocombine
--       highlight IndentRainbow6 guifg=#C678DD gui=nocombine
--
--       highlight SkkeletonIndicatorEiji guifg=#000000 guibg=#fffff0
--       highlight SkkeletonIndicatorHira guifg=#000000 guibg=#f0fff0
--       highlight SkkeletonIndicatorKata guifg=#000000 guibg=#e0ffff
--       highlight SkkeletonIndicatorHankata guifg=#000000 guibg=#fff8dc
--       highlight SkkeletonHenkan guifg=#fab387 gui=underline
--     ]])
--         apply_transparency()
--     end,
-- })

local colorscheme_group = vim.api.nvim_create_augroup("CustomColorscheme", { clear = true })

require("catppuccin").setup({
    flavour = "frappe",
    transparent_background = true,
    term_colors = true,
    styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        mason = true,
        noice = true,
        notify = true,
        which_key = true,
        bufferline = true,
        markdown = true,
        illuminate = true,
        indent_blankline = {
            enabled = true,
            scope_color = "sapphire",
            colored_indent_levels = false,
        },
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = {},
                hints = {},
                warnings = {},
                information = {},
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
        },
    },
})

vim.cmd.colorscheme("catppuccin")

vim.api.nvim_set_hl(0, "LineNr", { fg = "#9399b2", force = true })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e5c890", bold = true, force = true })

vim.api.nvim_create_autocmd("ColorScheme", {
    group = colorscheme_group,
    pattern = "*",
    callback = function()
        local colors = require("catppuccin.palettes").get_palette("frappe")
        if colors then
            vim.api.nvim_set_hl(0, "IndentRainbow1", { fg = colors.rosewater, nocombine = true })
            vim.api.nvim_set_hl(0, "IndentRainbow2", { fg = colors.flamingo, nocombine = true })
            vim.api.nvim_set_hl(0, "IndentRainbow3", { fg = colors.pink, nocombine = true })
            vim.api.nvim_set_hl(0, "IndentRainbow4", { fg = colors.mauve, nocombine = true })
            vim.api.nvim_set_hl(0, "IndentRainbow5", { fg = colors.lavender, nocombine = true })
            vim.api.nvim_set_hl(0, "IndentRainbow6", { fg = colors.text, nocombine = true })
        end
        --念のため再適用
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#9399b2", force = true })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e5c890", bold = true, force = true })
    end,
})
