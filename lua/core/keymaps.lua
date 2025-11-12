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

-- ▼▼▼ 【テーマパック】 キュンとする系・応援系 ▼▼▼
local yank_messages = {
    {
        title = "はい、どうぞ！",
        message = "さめまるくん、お疲れ様！ %s、ちゃんと持ってきたよ！",
    },
    {
        title = "頑張ってるね…！",
        message = "わぁ、%s も！ さめまるくんのコード、大切にコピーしとくね…！",
    },
    {
        title = "ふふっ…",
        message = "この %s、後で使うの？ うん、わかった。ちゃんと持ってるからね。",
    },
    {
        title = "おてつだい！",
        message = "さめまるくん、%s のコピー、手伝っちゃった！ えへへ…これで、いいかな？",
    },
    {
        title = "見てたよ",
        message = "…%s、コピーすると思った。はい、準備できてるよ。…頑張って。",
    },
}

-- ノーマルモード (オペレータ):
map("n", "<leader>c", '"+y', opts)

-- ビジュアルモード:
map("v", "<leader>c", function()
    -- 1. まず、Vim内部の "a レジスタに同期ヤンク
    vim.cmd('noautocmd normal! "ay')
    -- 2. 次に、OSのクリップボード "+ レジスタにヤンク (gvでビジュアル選択を復元)
    vim.cmd('noautocmd normal! gv"+y')

    -- 3. "a レジスタから (同期が保証された) テキストを取得
    local yanked_text = vim.fn.getreg("a")

    -- 4. "a レジスタの内容から行数を正確にカウント
    local lines_count = 0
    if yanked_text ~= "" then
        local nl_count = 0
        for _ in string.gmatch(yanked_text, "\n") do
            nl_count = nl_count + 1
        end
        if string.sub(yanked_text, -1) == "\n" then
            lines_count = nl_count
        else
            lines_count = nl_count + 1
        end
    else
        lines_count = 1
    end

    local lines_str = lines_count > 1 and lines_count .. "行" or "1行"

    -- 5. ランダムにメッセージを選択 (シードは init.lua で設定済み)
    local selected = yank_messages[math.random(1, #yank_messages)]
    local final_message = string.format(selected.message, lines_str)

    vim.notify(final_message, vim.log.levels.INFO, { title = selected.title })
end, opts)

-- ペーストはそのまま
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
