local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local messages = require("data.messages")

vim.opt.signcolumn = "yes"

map("n", "<leader>h", "<C-w>h", opts)
map("n", "<leader>j", "<C-w>j", opts)
map("n", "<leader>k", "<C-w>k", opts)
map("n", "<leader>l", "<C-w>l", opts)

map("t", "<C-h>", "<C-\\><C-n><C-w>h<cmd>checktime<CR>", opts)
map("t", "<C-j>", "<C-\\><C-n><C-w>j<cmd>checktime<CR>", opts)
map("t", "<C-k>", "<C-\\><C-n><C-w>k<cmd>checktime<CR>", opts)
map("t", "<C-l>", "<C-\\><C-n><C-w>l<cmd>checktime<CR>", opts)
map("t", "<C-g>", "<C-\\><C-n>", { noremap = true, silent = true, nowait = true })
map("i", "<C-g>", "<Esc>", { noremap = true, silent = true, nowait = true })
map("v", "<C-g>", "<Esc>", { noremap = true, silent = true, nowait = true })
map("c", "<C-g>", "<Esc>", { noremap = true, silent = true, nowait = true })
map("s", "<C-g>", "<Esc>", { noremap = true, silent = true, nowait = true })
map("o", "<C-g>", "<Esc>", { noremap = true, silent = true, nowait = true })
map("n", "<C-g>", "<Nop>", { noremap = true, silent = true, nowait = true })

map("t", "<C-Right>", "\x1bf")
map("t", "<C-Left>", "\x1bb")

local function format_and_save()
    local conform = require("conform")

    conform.format({ quiet = true }, function(err)
        if err and not err:find("No formatters available") then
            vim.notify("Conform (Format): " .. err, vim.log.levels.Error)
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

-- ヘルパー: レジスタの行数を数える
local function count_lines(text)
    if text == "" then
        return 1
    end
    local nl_count = 0
    for _ in string.gmatch(text, "\n") do
        nl_count = nl_count + 1
    end
    if string.sub(text, -1) == "\n" then
        return nl_count
    else
        return nl_count + 1
    end
end

local function lines_str(text)
    local n = count_lines(text)
    return n > 1 and n .. "行" or "1行"
end

local function notify_random(list, level, fmt_arg)
    local selected = list[math.random(1, #list)]
    local msg = fmt_arg and string.format(selected.message, fmt_arg) or selected.message
    vim.notify(msg, level, { title = selected.title })
end

map("n", "<leader>c", '"+y', opts)

map("v", "<leader>c", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"
    vim.cmd('noautocmd silent! normal! "ay')
    vim.cmd('noautocmd silent! normal! gv"+y')
    vim.o.shortmess = old_shortmess

    notify_random(messages.yank, vim.log.levels.INFO, lines_str(vim.fn.getreg("a")))
end, opts)

map({ "n", "v" }, "<leader>v", '"+p', opts)

map("n", "<leader>v", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"
    vim.cmd('noautocmd silent! normal! "+p')
    vim.o.shortmess = old_shortmess

    notify_random(messages.paste, vim.log.levels.INFO, lines_str(vim.fn.getreg("+")))
end, opts)

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

map("n", "<leader>d", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"
    vim.cmd('noautocmd silent! normal! "_dd')
    vim.o.shortmess = old_shortmess

    notify_random(messages.delete, vim.log.levels.WARN, "1行")
end, opts)

map("n", "dd", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"
    vim.cmd('noautocmd silent! normal! "_dd')
    vim.o.shortmess = old_shortmess

    notify_random(messages.delete, vim.log.levels.WARN, "1行")
end, opts)

map("v", "<leader>x", '"+d', opts)

map("n", "<leader>x", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"
    vim.cmd('noautocmd silent! normal! "+dd')
    vim.o.shortmess = old_shortmess

    notify_random(messages.cut, vim.log.levels.WARN, "1行")
end, opts)

map("n", "xx", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"
    vim.cmd('noautocmd silent! normal! "+dd')
    vim.o.shortmess = old_shortmess

    notify_random(messages.cut, vim.log.levels.WARN, "1行")
end, opts)

map("v", "d", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"
    vim.cmd('noautocmd silent! normal! "_d')
    vim.o.shortmess = old_shortmess

    notify_random(messages.delete, vim.log.levels.WARN, lines_str(vim.fn.getreg('"')))
end, opts)

map("v", "x", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"
    vim.cmd('noautocmd silent! normal! "+d')
    vim.o.shortmess = old_shortmess

    notify_random(messages.cut, vim.log.levels.WARN, lines_str(vim.fn.getreg("+")))
end, opts)

vim.keymap.set("v", "u", "<Esc>u", { noremap = true, silent = true })

-- TODO: Redoの操作要検討
-- vim.keymap.set("n", "y", "<C-r>", { noremap = true, silent = true })
-- vim.keymap.set("v", "y", "<Esc><C-r>", { noremap = true, silent = true })

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
        vim.fn["skkeleton#register_keymap"]("input", "<C-j>", "disable")
        vim.fn["skkeleton#register_keymap"]("input", "<C-g>", "escape")
        vim.fn["skkeleton#register_keymap"]("henkan", "<C-g>", "escape")
    end,
})

vim.keymap.set({ "i", "c" }, "<C-j>", [[<Plug>(skkeleton-toggle)]], { noremap = false })

-- nvim-surround
map("n", "<leader>w", "ysiw", { remap = true, desc = "Surround Word" })
map("n", "<leader>W", "yss", { remap = true, desc = "Surround Line" })
map("n", "<leader>dq", "dsq", { remap = true, desc = "Delete Quotes" })
map("n", "<leader>cq", "csq", { remap = true, desc = "Change Quote to ()" })
