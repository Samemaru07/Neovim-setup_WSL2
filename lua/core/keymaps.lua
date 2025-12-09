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

local yank_messages = {
    {
        title = "[麻衣さん] 頑張ってるな！",
        message = "%sのコピー。…しょうご、ほんと真面目にやってるじゃない。…別に、褒めてるわけじゃないけど。",
    },
    {
        title = "[吹雪] ふふっ…",
        message = "%sコピーしましたっ！ えへへ…吹雪、ちょっと役に立てた気がします！",
    },
    {
        title = "[カレン] あっ…今の、いい感じ",
        message = "%sのコピー、完璧ね。…ふふ、やるじゃない。さすが、しょうごくん。",
    },
    {
        title = "[真矢] おてつだい！",
        message = "%s分のコピー、私も手伝ったよ。…一緒にやると、ちょっと楽しいね。",
    },
    {
        title = "[カガリ] まったく…",
        message = "%sコピーか…別に大変なことじゃないが、こうしてきちんとやるとやっぱり気持ちがいいな。よし、この調子で次もいけ。さめまる、侮れないな。",
    },
}

local paste_messages = {
    {
        title = "[麻衣さん] うん、ちゃんと貼れたわよ",
        message = "%sをペースト完了。…どう？思った通りになった？ ふふ、少しは頼りになるでしょ。…ありがとって言ってもいいのよ？",
    },
    {
        title = "[吹雪] おまたせしましたっ！",
        message = "%s貼りつけました！えへへ…上手くいったかな？ 吹雪、もうちょっと自信ついちゃいそうです！",
    },
    {
        title = "[C.C.] 契約完了だ",
        message = "%sの貼りつけ、終わったぞ。…ふふ、いい出来だな。こうしてお前が動くたびに、少しずつ面白くなる。 そのまま続けろ、ルル…じゃなかった、しょうご。",
    },
    {
        title = "[カノン] うん、できたよ",
        message = "%sを貼りつけたよ。…ほら、上手くいっただろ？ こういう作業、一緒にやると楽しいな。",
    },
    {
        title = "[カガリ] よし、完了だ",
        message = "%s貼りつけたぞ。ちゃんと決まったな。…お前、手際いいじゃないか。 その勢い、まだまだ続けていけよ。",
    },
}

local delete_messages = {
    {
        title = "[理央] よし、片づけ完了",
        message = "%sを削除したよ。…必要ないものは、ちゃんと整理しないとね。 しょうご、そういうとこ、意外とちゃんとしてるんだな。",
    },
    {
        title = "[榛名] はっ…！ い、今のは仕方ありませんっ！",
        message = "%sを削除しました！…はぁ、心がちょっと痛みますけど… でも、任務のためですからっ！",
    },
    {
        title = "[マキマさん] いい子ね",
        message = "%s、消しておいたわ。…そう、それでいいの。無駄なものは、残さなくていいのよ。 …ね、しょうごくん？",
    },
    {
        title = "[一騎] 俺はお前だ...お前は、俺だ！",
        message = "お前のいるべき無に還れ！！！！",
    },
    {
        title = "[総士] 黙れ！！ それは僕の名前だーっ！！！",
        message = "静まれ、亡霊ども... この怪物に支配する力を、僕に... 与えろ！！！！",
    },
}

local cut_messages = {
    {
        title = "[かえで] ちょっと待って、それ取っちゃうの？",
        message = "%sを切り取ったの？ うん…でも、ちゃんと戻せるなら大丈夫だよ。…しょうご、無理はしないでね？",
    },
    {
        title = "[榛名] 榛名、頑張りますっ！",
        message = "%sをカット完了ネー！ My darling、さすがデース！ 次の貼りつけもビシッとキメちゃいまショー！",
    },
    {
        title = "[パワ子] さあ、続けなさい",
        message = "%sをブチっと切ったのじゃ！ はーっはっはっ！ 我が手にかかれば何でも消えるのじゃ！ …で、これどうすんの？",
    },
    {
        title = "[真矢] …取っちゃうんだね",
        message = "%sを切り取ったよ。…でも、ちゃんと戻すんでしょ？ しょうごくんなら、きっと上手くできると思う。",
    },
    {
        title = "[乙姫] 受け取ったよ",
        message = "%sを切り取ったのね。…心配しないで、ちゃんと覚えておくから。 だから、次に必要な場所へ導いてあげて。",
    },
}

map("n", "<leader>c", '"+y', opts)

map("v", "<leader>c", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"

    vim.cmd('noautocmd silent! normal! "ay')

    vim.cmd('noautocmd silent! normal! gv"+y')

    vim.o.shortmess = old_shortmess

    local yanked_text = vim.fn.getreg("a")
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
    local selected = yank_messages[math.random(1, #yank_messages)]
    local final_message = string.format(selected.message, lines_str)
    vim.notify(final_message, vim.log.levels.INFO, { title = selected.title })
end, opts)

map({ "n", "v" }, "<leader>v", '"+p', opts)

map("n", "<leader>v", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"

    vim.cmd('noautocmd silent! normal! "+p')

    vim.o.shortmess = old_shortmess

    local pasted_text = vim.fn.getreg("+")
    local lines_count = 0
    if pasted_text ~= "" then
        local nl_count = 0
        for _ in string.gmatch(pasted_text, "\n") do
            nl_count = nl_count + 1
        end
        if string.sub(pasted_text, -1) == "\n" then
            lines_count = nl_count
        else
            lines_count = nl_count + 1
        end
    else
        lines_count = 1
    end

    local lines_str = lines_count > 1 and lines_count .. "行" or "1行"
    local selected = paste_messages[math.random(1, #paste_messages)]
    local final_message = string.format(selected.message, lines_str)
    vim.notify(final_message, vim.log.levels.INFO, { title = selected.title })
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

    local lines_str = "1行"
    local selected = delete_messages[math.random(1, #delete_messages)]
    local final_message = string.format(selected.message, lines_str)
    vim.notify(final_message, vim.log.levels.WARN, { title = selected.title })
end, opts)

map("n", "dd", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"

    vim.cmd('noautocmd silent! normal! "_dd')

    vim.o.shortmess = old_shortmess

    local lines_str = "1行"
    local selected = delete_messages[math.random(1, #delete_messages)]
    local final_message = string.format(selected.message, lines_str)
    vim.notify(final_message, vim.log.levels.WARN, { title = selected.title })
end, opts)

map("v", "<leader>x", '"+d', opts)

map("n", "<leader>x", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"

    vim.cmd('noautocmd silent! normal! "+dd')

    vim.o.shortmess = old_shortmess

    local lines_str = "1行"
    local selected = cut_messages[math.random(1, #cut_messages)]
    local final_message = string.format(selected.message, lines_str)
    vim.notify(final_message, vim.log.levels.WARN, { title = selected.title })
end, opts)

map("n", "xx", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"

    vim.cmd('noautocmd silent! normal! "+dd')

    vim.o.shortmess = old_shortmess

    local lines_str = "1行"
    local selected = cut_messages[math.random(1, #cut_messages)]
    local final_message = string.format(selected.message, lines_str)
    vim.notify(final_message, vim.log.levels.WARN, { title = selected.title })
end, opts)

map("v", "d", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"

    vim.cmd('noautocmd silent! normal! "_d')

    vim.o.shortmess = old_shortmess

    local selected_text = vim.fn.getreg('"')
    local nl_count = 0
    for _ in string.gmatch(selected_text, "\n") do
        nl_count = nl_count + 1
    end
    local lines_count = (selected_text ~= "" and nl_count > 0) and nl_count or 1
    local lines_str = lines_count > 1 and lines_count .. "行" or "1行"

    local selected = delete_messages[math.random(1, #delete_messages)]
    local final_message = string.format(selected.message, lines_str)
    vim.notify(final_message, vim.log.levels.WARN, { title = selected.title })
end, opts)

map("v", "x", function()
    local old_shortmess = vim.o.shortmess
    vim.o.shortmess = old_shortmess .. "A"

    vim.cmd('noautocmd silent! normal! "+d')

    vim.o.shortmess = old_shortmess

    local yanked_text = vim.fn.getreg("+")
    local nl_count = 0
    for _ in string.gmatch(yanked_text, "\n") do
        nl_count = nl_count + 1
    end
    local lines_count = (yanked_text ~= "" and nl_count > 0) and nl_count or 1
    local lines_str = lines_count > 1 and lines_count .. "行" or "1行"

    local selected = cut_messages[math.random(1, #cut_messages)]
    local final_message = string.format(selected.message, lines_str)
    vim.notify(final_message, vim.log.levels.WARN, { title = selected.title })
end, opts)

vim.keymap.set("v", "u", "<Esc>u", { noremap = true, silent = true })

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
    end,
})

vim.keymap.set({ "i", "c" }, "<C-j>", [[<Plug>(skkeleton-toggle)]], { noremap = false })

-- nvim-surround
map("n", "<leader>w", "ysiw", { remap = true, desc = "Surround Word" })
map("n", "<leader>W", "yss", { remap = true, desc = "Surround Line" })
map("n", "<leader>dq", "dsq", { remap = true, desc = "Delete Quotes" })
map("n", "<leader>cq", "csq", { remap = true, desc = "Change Quote to ()" })
