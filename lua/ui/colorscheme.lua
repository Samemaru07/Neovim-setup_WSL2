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

require("kanagawa").setup({
    transparent = true,
    theme = "wave",
    colors = {
        palette = {
            -- 紫をパステル＆青寄りに調整
            oniViolet = "#A0A8D8",      -- 元 #957FB8 → パステルブルーバイオレット
            springViolet1 = "#9AA2C8",   -- 元 #938AA9 → 淡い青紫
            springViolet2 = "#A4B8DA",   -- 元 #9CABCA → やや明るい青紫
        },
        theme = {
            all = {
                ui = {
                    bg_gutter = "none",
                },
            },
        },
    },
    overrides = function(colors)
        return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            -- タブライン全体のベース背景を透明化
            TabLineFill = { bg = "none" },
            TabLine = { bg = "none" },
            Visual = { bg = "#82827F" },
        }
    end,
})

-- bufferlineの全ハイライトのguibgをNONEにする
local function bufferline_transparent()
    for _, name in ipairs(vim.fn.getcompletion("BufferLine", "highlight")) do
        vim.cmd("highlight " .. name .. " guibg=NONE")
    end
    vim.cmd("highlight TabLineFill guibg=NONE")
end

-- bufferlineの全ハイライトのguibgを黒にする
local function bufferline_opaque()
    for _, name in ipairs(vim.fn.getcompletion("BufferLine", "highlight")) do
        vim.cmd("highlight " .. name .. " guibg=#16161D")
    end
    vim.cmd("highlight TabLineFill guibg=#16161D")
end

-- dashboard表示中かどうかでbufferlineの透明/不透明を切り替える
local function update_bufferline_bg()
    local is_alpha = vim.bo.filetype == "alpha"
    if is_alpha then
        bufferline_transparent()
    else
        bufferline_opaque()
    end
end

-- ColorScheme変更時にも再適用
vim.api.nvim_create_autocmd("ColorScheme", {
    group = colorscheme_group,
    pattern = "*",
    callback = function()
        local palette = require("kanagawa.colors").setup().palette

        -- インデントライン：金 → 紫 → 青グラデ
        vim.api.nvim_set_hl(0, "IndentRainbow1", { fg = palette.autumnYellow, nocombine = true })
        vim.api.nvim_set_hl(0, "IndentRainbow2", { fg = palette.autumnOrange, nocombine = true })
        vim.api.nvim_set_hl(0, "IndentRainbow3", { fg = palette.oniViolet, nocombine = true })
        vim.api.nvim_set_hl(0, "IndentRainbow4", { fg = palette.crystalBlue, nocombine = true })
        vim.api.nvim_set_hl(0, "IndentRainbow5", { fg = palette.springBlue, nocombine = true })
        vim.api.nvim_set_hl(0, "IndentRainbow6", { fg = palette.fujiWhite, nocombine = true })

        -- 行番号
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#C8B88A", force = true })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#E6C86E", bold = true, force = true })

        -- NvimTree フォルダ色
        vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#abb5ff" })
        vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#abb5ff" })
        vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#abb5ff", bold = true })

        -- Visualモードの選択範囲を見やすくする
        vim.api.nvim_set_hl(0, "Visual", { bg = "#82827F", bold = true })

        vim.schedule(update_bufferline_bg)
    end,
})

-- VimEnter: 起動時（dashboard表示中）は透明
vim.api.nvim_create_autocmd("VimEnter", {
    group = colorscheme_group,
    callback = function()
        vim.schedule(update_bufferline_bg)
    end,
})

-- バッファ切り替え時に透明/黒を自動切り替え
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    group = colorscheme_group,
    callback = function()
        vim.schedule(update_bufferline_bg)
    end,
})

-- 基本の視認性調整
vim.api.nvim_set_hl(0, "LineNr", { fg = "#C8B88A", force = true })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#E6C86E", bold = true, force = true })

vim.cmd.colorscheme("kanagawa")
