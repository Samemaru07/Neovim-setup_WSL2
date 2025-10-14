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
require("ui.indent")
require("ui.dashboard")

require("lsp.lsp")
require("cmp.cmp")
require("ui.trouble")

local data_dir   = vim.fn.stdpath("data")
local swap_dir   = data_dir .. "/swap//"
local backup_dir = data_dir .. "/backup//"
local undo_dir   = data_dir .. "/undo//"

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
    end
})

-- spectreのswapファイルは作らせない
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "spectre",
    callback = function()
        vim.opt_local.swapfile = false
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.cmd("VimtexCompile")
    end
})
