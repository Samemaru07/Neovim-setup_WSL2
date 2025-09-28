local toggleterm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal

-- 基本設定
toggleterm.setup({
    size = 10,
    direction = "horizontal",
    start_in_insert = true,
    close_on_exit = false,
    on_open = function(term)
        vim.api.nvim_buf_set_name(term.bufnr, "ターミナル #" .. term.count)
        vim.api.nvim_win_set_option(term.window, "winhighlight", "Normal:Normal")
    end,
})

-- ターミナル管理
local terms = {}
local max_terms = 3
local current_term = nil

-- ターミナル #1 を初期作成
terms[1] = Terminal:new({
    count = 1,
    cmd = "wsl.exe",
    direction = "horizontal",
    start_in_insert = true,
    close_on_exit = false,
    on_open = function(term)
        vim.api.nvim_buf_set_name(term.bufnr, "ターミナル #1")
        vim.api.nvim_win_set_option(term.window, "winhighlight", "Normal:Normal")
    end,
})

-- ターミナル開閉関数
local function create_toggle_func(i)
    return function()
        if not terms[i] then
            terms[i] = Terminal:new({
                count = i,
                cmd = "wsl.exe",
                direction = "horizontal",
                start_in_insert = true,
                close_on_exit = false,
                on_open = function(term)
                    vim.api.nvim_buf_set_name(term.bufnr, "ターミナル #" .. i)
                    vim.api.nvim_win_set_option(term.window, "winhighlight", "Normal:Normal")
                end,
            })
        end
        terms[i]:toggle()
        current_term = i
        print("現在のターミナル: " .. i)
    end
end

-- キーマッピング
-- ターミナル #1 開閉
vim.keymap.set("n", "<leader>t", create_toggle_func(1), { noremap = true, silent = true })

-- ターミナル #2, #3 開閉
for i = 2, max_terms do
    vim.keymap.set("n", "<leader>t" .. i, create_toggle_func(i), { noremap = true, silent = true })
end

-- 新しいターミナル作成（#2, #3のみ）
vim.keymap.set("n", "<leader>n", function()
    for i = 2, max_terms do
        if not terms[i] then
            terms[i] = Terminal:new({
                count = i,
                cmd = "wsl.exe",
                direction = "horizontal",
                start_in_insert = true,
                close_on_exit = false,
                on_open = function(term)
                    vim.api.nvim_buf_set_name(term.bufnr, "ターミナル #" .. i)
                    vim.api.nvim_win_set_option(term.window, "winhighlight", "Normal:Normal")
                end,
            })
            terms[i]:toggle()
            current_term = i
            print("新しいターミナル作成: " .. i)
            return
        end
    end
    print("既に3つのターミナルがあります")
end, { noremap = true, silent = true })

-- 特定ターミナル削除: <leader>d1, d2, d3
for i = 1, max_terms do
    vim.keymap.set("n", "<leader>d" .. i, function()
        if terms[i] then
            terms[i]:close()
            terms[i] = nil
            print("ターミナル " .. i .. " を削除しました")
            if current_term == i then
                current_term = nil
            end
        else
            print("ターミナル " .. i .. " は開かれていません")
        end
    end, { noremap = true, silent = true })
end

-- 現在のターミナルを削除: <leader>td
vim.keymap.set("n", "<leader>td", function()
    if current_term and terms[current_term] then
        terms[current_term]:close()
        terms[current_term] = nil
        print("現在のターミナル " .. current_term .. " を削除しました")
        current_term = nil
    else
        print("現在開いているターミナルはありません")
    end
end, { noremap = true, silent = true })

-- ターミナル自動挿入モード
vim.cmd [[
  autocmd TermOpen * startinsert
]]

_G.ToggleTermState = {
    current = function()
        return current_term
    end
}
