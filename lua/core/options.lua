vim.o.number = true
vim.o.relativenumber = false
vim.opt.clipboard = "unnamedplus"
vim.o.termguicolors = true

-- インデント設定
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("Lazy.nvim not found. Please run git clone.")
end
vim.opt.rtp:prepend(lazypath)

vim.opt.shell = vim.env.SHELL or "/bin/sh"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
vim.opt.showmode = false

-- 改行コード
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos", "mac" }
