-- NvimTree のステータスライン
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "NvimTree_*",
    callback = function()
        vim.opt_local.statusline = "Explorer"
    end,
})

-- spectre バッファのスワップ無効化
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "spectre",
    callback = function()
        vim.opt_local.swapfile = false
    end,
})

-- 外部変更の自動リロード
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    command = "checktime",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    callback = function()
        vim.notify(
            "🔄 ファイルが外部で変更されたため、再読み込みしました。",
            vim.log.levels.INFO,
            { title = "Auto Reload" }
        )
    end,
})

-- Verilog / SystemVerilog のファイルタイプ設定
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.v", "*.sv" },
    callback = function()
        vim.bo.filetype = "verilog"
    end,
})

-- nvim config の自動リロード
local nvim_reload_group = vim.api.nvim_create_augroup("NvimConfigReload", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
    group = nvim_reload_group,
    pattern = {
        vim.fn.stdpath("config") .. "/*.lua",
        vim.fn.stdpath("config") .. "/**/*.lua",
    },
    callback = function()
        for name, _ in pairs(package.loaded) do
            if
                name ~= "core.plugins"
                and (
                    name:match("^core")
                    or name:match("^ui")
                    or name:match("^lsp")
                    or name:match("^cmp")
                    or name:match("^snippets")
                    or name == "nvim-web-devicons"
                    or name == "bufferline"
                    or name == "lualine"
                )
            then
                package.loaded[name] = nil
            end
        end

        local ok, err = pcall(dofile, vim.fn.stdpath("config") .. "/init.lua")

        if ok then
            vim.schedule(function()
                pcall(function()
                    require("nvim-web-devicons").setup()
                    vim.api.nvim_command("colorscheme kanagawa")
                    require("ui.bufferline")
                    require("ui.lualine")
                    require("nvim-tree.api").tree.reload()
                end)
            end)
            vim.notify("🚀 設定を自動リロードしました！", vim.log.levels.INFO, { title = "Config" })
        else
            vim.notify("❌ リロード失敗: " .. err, vim.log.levels.ERROR, { title = "Config Error" })
        end
    end,
})

-- tmux config の自動リロード
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = os.getenv("HOME") .. "/.tmux.conf",
    callback = function()
        local output = vim.fn.system("tmux source-file " .. os.getenv("HOME") .. "/.tmux.conf")
        if vim.v.shell_error == 0 then
            vim.notify("Tmux configuration reloaded!", vim.log.levels.INFO, { title = "Tmux" })
        else
            vim.notify("Failed to reload tmux configuration: " .. output, vim.log.levels.ERROR, { title = "Tmux" })
        end
    end,
})
