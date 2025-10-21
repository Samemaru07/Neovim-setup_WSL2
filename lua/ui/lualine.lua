require("lualine").setup({
    options = {
        theme = "vscode",
        globalstatus = false,
        disabled_filetypes = { "alpha" },
    },
    sections = {
        lualine_a = {
            {
                "mode",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
            },
        },
        lualine_b = {
            {
                "branch",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
            },
            {
                "filename",
                path = 1,
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
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
                    if vim.bo.buftype == "terminal" then
                        local bufnr = vim.api.nvim_get_current_buf()
                        local name = vim.api.nvim_buf_get_name(bufnr)
                        name = vim.fn.fnamemodify(name, ":t")
                        local m = vim.api.nvim_get_mode().mode

                        if m == "t" then
                            return name .. " -- TERMINAL --"
                        else
                            return name .. " -- TERMINAL-NORMAL --"
                        end
                    end
                    return ""
                end,
                color = function()
                    if vim.bo.buftype == "terminal" then
                        local m = vim.api.nvim_get_mode().mode
                        if m == "t" then
                            return { fg = "#ffffff", bg = "#d19a66" }
                        else
                            return { fg = "#ffffff", bg = "#61afef" }
                        end
                    end
                    return nil
                end,
            },
        },
        lualine_y = {
            {
                "progress",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
            },
        },
        lualine_z = {
            {
                "location",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "NvimTree"
                end,
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
