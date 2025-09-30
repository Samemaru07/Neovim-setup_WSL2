require("lualine").setup({
    options = {
        theme = "vscode",
        globalstatus = true,
        disabled_filetypes = { "alpha" }
    },
    sections = {
        lualine_a = {
            {
                "mode",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha"
                end
            },
        },
        lualine_b = {
            {
                "branch",
                cond = function()
                    return vim.bo.filetype ~= "alpha"
                end
            },
        },
        lualine_c = {
            {
                function()
                    if vim.bo.buftype == "terminal" then
                        local term_num = _G.ToggleTermState and _G.ToggleTermState.current() or "?"
                        local m = vim.api.nvim_get_mode().mode
                        if m == "t" then
                            return "ターミナル #" .. term_num .. " -- TERMINAL --"
                        else
                            return "ターミナル #" .. term_num .. " -- TERMINAL-NORMAL --"
                        end
                    end

                    -- ファイルバッファの場合の処理
                    local ft = vim.bo.filetype
                    if ft == "NvimTree" then return "エクスプローラ" end
                    if ft == "alpha" then return "" end

                    local bufnr = vim.api.nvim_get_current_buf()
                    local name = vim.api.nvim_buf_get_name(bufnr)
                    if name ~= "" then
                        name = vim.fn.fnamemodify(name, ":t")
                    end

                    return vim.bo.modified
                        and (name .. " そんなファイル、保存してやる！！")
                        or (name .. " 保存しておけばどうということはない！")
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
                end
            }
        },

        lualine_x = {},
        lualine_y = {
            {
                "progress",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha"
                end
            }
        },
        lualine_z = {
            {
                "location",
                cond = function()
                    return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "alpha"
                end
            }
        }
    }
})
