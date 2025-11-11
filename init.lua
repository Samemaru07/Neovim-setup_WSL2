vim.g.mapleader = " "

require("core.options")
require("core.keymaps")
require("core.plugins")
require("core.lint")

require("ui.colorscheme")
require("ui.lualine")
require("ui.bufferline")
require("ui.nvim-tree")
require("ui.toggleterm")
require("ui.dashboard")

require("cmp.cmp")
require("ui.trouble")

local data_dir = vim.fn.stdpath("data")
local swap_dir = data_dir .. "/swap//"
local backup_dir = data_dir .. "/backup//"
local undo_dir = data_dir .. "/undo//"

local function ensure_dir(path)
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
    end
end

ensure_dir(swap_dir)
ensure_dir(backup_dir)
ensure_dir(undo_dir)

-- スワップファイル
vim.o.swapfile = true
vim.o.directory = swap_dir

-- バックアップ
vim.o.backup = true
vim.o.backupdir = backup_dir

-- Undo ファイル
vim.o.undofile = true
vim.o.undodir = undo_dir

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "NvimTree_*",
    callback = function()
        vim.opt_local.statusline = "Explorer"
    end,
})

-- spectreのswapファイルは作らせない
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "spectre",
    callback = function()
        vim.opt_local.swapfile = false
    end,
})

-- 折り返し
vim.o.wrap = false

vim.o.autoread = true

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

if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
        name = "win32yank-wsl",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
end

-- プラグインロード後に setup を呼ぶ
require("flutter-tools").setup({
    flutter_path = "/home/samemaru/development/flutter/bin/flutter",
    widget_guides = { enabled = true },
    decorations = { statusline = { device = true } },
    dev_log = { enabled = true, open_cmd = "tabnew" },
    outline = { open_cmd = "30vsplit" },
})

-- プロジェクトディレクトリに入った状態でコマンドを登録
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        local cwd = vim.fn.getcwd()
        if vim.fn.isdirectory(cwd .. "/lib") == 1 then
            require("flutter-tools").setup_project()
        end
    end,
})
