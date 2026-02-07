local toggleterm = require("toggleterm")

local last_focused_term = nil

toggleterm.setup({
    size = 10,
    direction = "horizontal",
    start_in_insert = true,
    close_on_exit = false,
    on_open = function(term)
        vim.api.nvim_buf_set_name(term.bufnr, "ターミナル #" .. term.id)
        vim.api.nvim_win_set_option(term.window, "winhighlight", "Normal:Normal")
        last_focused_term = term
    end,
    on_focus = function(term)
        last_focused_term = term
    end,
    on_close = function(term)
        if last_focused_term and last_focused_term.id == term.id then
            last_focused_term = nil
        end
    end,
})

vim.keymap.set("n", "<leader>t", function()
    require("toggleterm").toggle_command("horizontal")
end, { noremap = true, silent = true, desc = "Toggle horizontal terminal section" })

vim.keymap.set("n", "<leader>n", function()
    local Terminal = require("toggleterm.terminal").Terminal
    local new_term = Terminal:new({ direction = "horizontal" })
    new_term:open()
end, { noremap = true, silent = true, desc = "New terminal tab" })

vim.keymap.set("n", "<leader>td", function()
    if vim.bo.buftype == "terminal" then
        vim.cmd("bdelete!")
    elseif last_focused_term and last_focused_term.bufnr and vim.fn.bufexists(last_focused_term.bufnr) == 1 then
        vim.cmd("bdelete! " .. last_focused_term.bufnr)
        last_focused_term = nil
    else
        print("削除するターミナルが見つかりません")
    end
end, { noremap = true, silent = true, desc = "Delete current/last focused terminal" })

vim.cmd([[
  autocmd TermOpen * startinsert
]])

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
        end
    end,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    close_on_exit = true,
})

function _lazygit_toggle()
    lazygit:toggle()
end

vim.keymap.set("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true, desc = "Toggle lazygit" })
