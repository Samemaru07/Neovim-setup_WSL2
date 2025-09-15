vim.o.number = true
vim.o.relativenumber = false
vim.opt.clipboard = "unnamedplus"
vim.o.termguicolors = true

-- =========================================
-- インデント設定 (Tab = 4スペース)
-- =========================================
vim.o.tabstop = 4        -- 画面上でのタブ幅
vim.o.shiftwidth = 4     -- 自動インデントの幅
vim.o.softtabstop = 4    -- TabキーやBackspaceの挙動を4スペースに
vim.o.expandtab = true   -- タブをスペースに変換
vim.o.smartindent = true -- 新しい行で自動インデント

-- =========================================
-- Lazy.nvim setup
-- =========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("Lazy.nvim not found. Please run git clone.")
end
vim.opt.rtp:prepend(lazypath)

-- Neovim のターミナルを wslのbashに
vim.opt.shell = "/bin/bash"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
vim.opt.showmode = false


-- 改行コード
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos", "mac" }
