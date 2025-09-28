local map = vim.keymap.set
local opts = { noremap = true, silent = true }


-- サイン列を常に表示（エラー列用）
vim.opt.signcolumn = "yes"


-- ウィンドウ移動
map("n", "<leader>h", "<C-w>h", opts)
map("n", "<leader>j", "<C-w>j", opts)
map("n", "<leader>k", "<C-w>k", opts)
map("n", "<leader>l", "<C-w>l", opts)

map("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
map("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
map("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
map("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)
map("t", "<Esc>", "<C-\\><C-n>", opts)


-- 保存 + LSP整形
local function format_and_save()
    local ok = pcall(function()
        vim.lsp.buf.format({ async = false })
    end)

    if not ok then
        print("LSP フォーマッタが見つかりませんでした")
    end

    vim.cmd("write")
end

map({ "n", "v" }, "<leader>s", format_and_save, opts)

map({ "n", "v" }, "<leader>sq", function()
    format_and_save()
    vim.cmd("bdelete")
end, opts)

map("n", "<leader>q", "<cmd>bdelete!<CR>", opts)

map({ "n", "i" }, "<C-S-s>", function()
    format_and_save(); vim.cmd("quit")
end, opts)


-- コピー・ペースト
map({ "n", "v" }, "<leader>c", '"+y', opts)
map({ "n", "v" }, "<leader>v", '"+p', opts)

map("i", "<C-c>", '<C-o>"+y', opts)
map("i", "<C-v>", '<C-o>"+p', opts)


-- 全選択
local function select_all() vim.cmd("normal! ggVG") end
map({ "n", "v" }, "<leader>a", select_all, opts)


-- ウィンドウ操作（リサイズ）
local resize_maps = {
    ["<A-Up>"] = "<cmd>resize +2<CR>",
    ["<A-Down>"] = "<cmd>resize -2<CR>",
    ["<A-Left>"] = "<cmd>vertical resize -2<CR>",
    ["<A-Right>"] = "<cmd>vertical resize +2<CR>",
}

for k, cmd in pairs(resize_maps) do
    map({ "n", "i", "v" }, k, "<Esc>" .. cmd .. "i", opts)
    map("n", k, cmd, opts)
    map("t", k, "<C-\\><C-n>" .. cmd .. "i", opts)
end


-- 行移動（<leader>↑↓）
map({ "n", "v" }, "<leader><Up>", "ddkP", opts)
map({ "n", "v" }, "<leader><Down>", "ddp", opts)


-- 行複製（<leader>cu, <leader>cd）
map({ "n", "v" }, "<leader>cu", "yypk", opts)
map({ "n", "v" }, "<leader>cd", "yyp", opts)


-- 行削除（ヤンクなし）
map({ "n", "v" }, "<leader>d", '"_dd', opts)


-- 行切り取り（ヤンクあり）
map("n", "<leader>x", "dd", opts)
map("v", "<leader>x", "d", opts)


-- コメントアウト
map("n", "<leader>/", function() require("core.comment").toggle_comment() end, opts)
map("v", "<leader>/", function() require("core.comment").toggle_visual() end, opts)


-- Undo / Redo
vim.keymap.set("n", "<C-z>", "u", { noremap = true, silent = true })
vim.keymap.set("i", "<C-z>", "<C-o>u", { noremap = true, silent = true })

vim.keymap.set("n", "<C-q>", "<C-r>", { noremap = false, silent = true })
vim.keymap.set("i", "<C-q>", "<C-o><C-r>", { noremap = false, silent = true })


-- 単語削除
vim.keymap.set("i", "<C-e>", "<C-w>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-r>", "<C-o>de", { noremap = true, silent = true })


-- ペイン分割
map({ "n", "v" }, "<leader>bv", "<cmd>vsplit<CR>", opts)
map({ "n", "v" }, "<leader>bh", "<cmd>split<CR>", opts)


-- NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)


-- Bufferline
for i = 1, 9 do
    map("n", "<leader>" .. i, function()
        require("bufferline").go_to(i, true)
    end, opts)
end


-- Trouble
map("n", "<leader>m", function()
    local trouble = require("trouble")

    if trouble.is_open() then
        trouble.close()
    else
        trouble.open("diagnostics")
    end
end, opts)
