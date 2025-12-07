local function skkeleton_mode()
    local mode = vim.fn["skkeleton#mode"]()
    if mode == "hira" then
        return "[あ]"
    elseif mode == "kata" then
        return "[ア]"
    elseif mode == "hankata" then
        return "[ｱ]"
    else
        return "[A]"
    end
end

require("lualine").setup({
    options = {
        theme = "auto",
        globalstatus = false,
        disabled_filetypes = { "alpha" },
    },
    sections = {
        lualine_a = {
            {
                "noice",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
            },
            {
                function()
                    if vim.bo.buftype == "terminal" then
                        local bufnr = vim.api.nvim_get_current_buf()
                        local name = vim.api.nvim_buf_get_name(bufnr)
                        name = vim.fn.fnamemodify(name, ":t")
                        local m = vim.api.nvim_get_mode().mode

                        if m == "t" then
                            return name .. "  -- TERMINAL --"
                        else
                            return name .. "  -- TERMINAL-NORMAL --"
                        end
                    end
                    return ""
                end,
                color = function()
                    if vim.bo.buftype == "terminal" then
                        local m = vim.api.nvim_get_mode().mode
                        if m == "t" then
                            return { fg = "#000000", bg = "#d19a66" }
                        else
                            return { fg = "#000000", bg = "#61afef" }
                        end
                    end
                    return nil
                end,
                separator = { right = "" },
            },
        },
        lualine_b = {
            {
                "filename",
                path = 1,
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                color = { fg = "#000000", bg = "#708090" },
                separator = { right = "" },
            },
            {
                "branch",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                color = { fg = "#000000", bg = "#778899" },
                separator = { right = "" },
            },
        },
        lualine_c = {
            {
                function()
                    if vim.bo.buftype == "terminal" then
                        return ""
                    end
                    local ft = vim.bo.filetype
                    if ft == "NvimTree" then
                        return "エクスプローラ"
                    end
                    if ft == "alpha" then
                        return ""
                    end

                    if vim.bo.modified then
                        return "そんなファイル、保存してやる！！"
                    else
                        return "保存しておけばどうということはない！"
                    end
                end,
                color = nil,
            },
        },
        lualine_x = {
            {
                function()
                    return ""
                end,
            },
        },
        lualine_y = {
            {
                "progress",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                color = { fg = "#000000", bg = "#778899" },
            },
        },
        lualine_z = {
            {
                "location",
                cond = function()
                    return vim.bo.buftype == "" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                color = { fg = "#000000", bg = "#778899" },
            },
            {
                skkeleton_mode,
                cond = function()
                    -- ターミナルでは非表示、それ以外では表示
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha"
                end,
                color = { fg = "#000000", bg = "#5f676f" },
                padding = { left = 1, right = 1 },
                separator = { fg = "#ffffff", left = "" },
            },
            {
                "filetype",
                cond = function()
                    return vim.bo.buftype == "" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                colored = true,
                padding = { left = 1, right = 1 },
                color = { fg = "#000000", bg = "#708090" },
                separator = { left = "" },
            },
            {
                "encoding",
                cond = function()
                    return vim.bo.buftype == "" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
                padding = { left = 1, right = 1 },
                color = { fg = "#000000", bg = "#708090" },
                separator = { left = "" },
            },
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                function()
                    if vim.bo.filetype == "NvimTree" then
                        return "エクスプローラ"
                    end
                    return ""
                end,
            },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
})
