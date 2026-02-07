vim.o.number = true
vim.o.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.o.termguicolors = true

-- インデント設定
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = false
vim.o.autoindent = true

vim.o.shell = vim.env.SHELL or "/bin/sh"
vim.o.shellcmdflag = "-c"
vim.o.showmode = false

-- 改行コード
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos", "mac" }

-- キーの判定速度
vim.o.ttimeoutlen = 50
vim.o.timeoutlen = 500

vim.o.scrolloff = 2

vim.o.autoread = true

vim.o.cmdheight = 0

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        source = "always",
        border = "rounded",
    },
})
