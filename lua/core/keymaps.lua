local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.opt.signcolumn = "yes"

map("n", "<leader>h", "<C-w>h", opts)
map("n", "<leader>j", "<C-w>j", opts)
map("n", "<leader>k", "<C-w>k", opts)
map("n", "<leader>l", "<C-w>l", opts)

map("t", "<C-h>", "<C-\\><C-n><C-w>h<cmd>checktime<CR>", opts)
map("t", "<C-j>", "<C-\\><C-n><C-w>j<cmd>checktime<CR>", opts)
map("t", "<C-k>", "<C-\\><C-n><C-w>k<cmd>checktime<CR>", opts)
map("t", "<C-l>", "<C-\\><C-n><C-w>l<cmd>checktime<CR>", opts)
map("t", "<Esc>", "<C-\\><C-n>", opts)

map("t", "<C-Right>", "\x1bf")
map("t", "<C-Left>", "\x1bb")

local function format_and_save()
    local conform = require("conform")

    conform.format(nil, function(err)
        if err then
            vim.notify("Conform (Format): " .. err, vim.log.levels.ERROR)
        end
        vim.cmd("write")
    end)
end

vim.keymap.set({ "n", "v" }, "<leader>s", format_and_save, { noremap = true, silent = true })

map({ "n", "v" }, "<leader>sq", function()
    format_and_save()
    vim.cmd("bdelete")
end, opts)

map("n", "<leader>q", "<cmd>bdelete!<CR>", opts)

map({ "n", "i" }, "<C-S-s>", function()
    format_and_save()
    vim.cmd("quit")
end, opts)

map({ "n", "v" }, "<leader>c", '"+y', opts)
map({ "n", "v" }, "<leader>v", '"+p', opts)

map("i", "<C-c>", '<C-o>"+y', opts)
map("i", "<C-v>", '<C-o>"+p', opts)

local function select_all()
    vim.cmd("normal! ggVG")
end
map({ "n", "v" }, "<leader>a", select_all, opts)

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

map({ "n", "v" }, "<leader>c<Up>", "ddkP", opts)
map({ "n", "v" }, "<leader>c<Down>", "ddp", opts)
map("v", "<leader><Up>", ":m '<-2<CR>gv=gv", opts)
map("v", "<leader><Down>", ":m '>+1<CR>gv=gv", opts)

map({ "n", "v" }, "<leader>cu", "yypk", opts)
map({ "n", "v" }, "<leader>cd", "yyp", opts)

map("n", "dd", '"_dd', opts)

map("n", "<leader>x", '"+dd', opts)
map("v", "<leader>x", '"+d', opts)
map("n", "xx", '"+dd', opts)

vim.keymap.set("n", "<leader>z", "u", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>z", "<Esc>u", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>y", "<C-r>", { noremap = true, silent = true })

vim.keymap.set("i", "<C-h>", "<C-w>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-h>", "db", { noremap = true, silent = true })
vim.keymap.set("t", "<C-h>", "<C-E>", { noremap = true, silent = true })

vim.keymap.set("i", "<C-l>", "<C-o>de", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "de", { noremap = true, silent = true })
vim.keymap.set("t", "<C-l>", "<C-r>", { noremap = true, silent = true })

map({ "n", "v" }, "<leader>bv", "<cmd>vsplit<CR>", opts)
map({ "n", "v" }, "<leader>bh", "<cmd>split<CR>", opts)

map("n", "<leader>fc", function()
    require("spectre").open()
end, opts)

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)

for i = 1, 9 do
    map("n", "<leader>" .. i, function()
        require("bufferline").go_to(i, true)
    end, opts)
end

map("n", "<leader>rr", function()
    for name, _ in pairs(package.loaded) do
        if name:match("^core") or name:match("^ui") then
            package.loaded[name] = nil
        end
    end
    dofile(vim.fn.stdpath("config") .. "/init.lua")
    vim.notify("Neovim Config Reloaded (Full)!", vim.log.levels.INFO)
end, opts)

map("n", "zz", "zz", opts)

map("n", "<leader>.", "<cmd>BufferLineCycleNext<CR>", opts)
map("n", "<leader>,", "<cmd>BufferLineCyclePrev<CR>", opts)

vim.keymap.set("n", "+", "<C-a>", { noremap = true, silent = true })
vim.keymap.set("n", "-", "<C-x>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<S-e>", "%", { noremap = true, silent = true })

map({ "n", "v" }, "<leader><Up>", ":m .-2<CR>==", opts)
map({ "n", "v" }, "<leader><Down>", ":m .+1<CR>==", opts)
map("v", "<leader><Up>", ":m '<-2<CR>gv=gv", opts)
map("v", "<leader><Down>", ":m '>+1<CR>gv=gv", opts)

vim.api.nvim_create_autocmd("User", {
    pattern = "skkeleton-initialize-pre",
    callback = function()
        vim.fn["skkeleton#register_keymap"]("input", "q", "katakana")
        vim.fn["skkeleton#register_keymap"]("input", "Q", "hankatakana")
    end,
})

vim.keymap.set({ "i", "c" }, "<C-j>", [[<Plug>(skkeleton-toggle)]], { noremap = false })
