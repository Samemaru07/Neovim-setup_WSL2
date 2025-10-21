local toggleterm = require("toggleterm")

local last_focused_term_id = nil

toggleterm.setup({
    size = 8,
    direction = "horizontal",
    start_in_insert = true,
    close_on_exit = false,
    on_open = function(term)
        vim.api.nvim_buf_set_name(term.bufnr, "ターミナル #" .. term.id)
        vim.api.nvim_win_set_option(term.window, "winhighlight", "Normal:Normal")
        last_focused_term_id = term.id
    end,
    on_focus = function(term)
        last_focused_term_id = term.id
    end,
    on_close = function(term)
        if last_focused_term_id == term.id then
            last_focused_term_id = nil
        end
    end,
})

vim.keymap.set("n", "<leader>t", function()
    require("toggleterm").toggle_command("horizontal")
end, { noremap = true, silent = true, desc = "Toggle horizontal terminal section" })

vim.keymap.set("n", "<leader>n", function()
    local Terminal = require("toggleterm.terminal").Terminal
    local new_term = Terminal:new({ cmd = "wsl.exe -e zsh", direction = "horizontal" })
    new_term:open()
end, { noremap = true, silent = true, desc = "New terminal tab" })

vim.keymap.set("n", "<leader>td", function()
    local state = require("toggleterm.state")
    local term_to_close = nil

    if vim.bo.buftype == "terminal" then
        term_to_close = state.get_current_term()
    elseif last_focused_term_id then
        term_to_close = state.get_term(last_focused_term_id)
    end

    if term_to_close then
        term_to_close:close()
    else
        print("閉じるターミナルが見つかりません")
    end
end, { noremap = true, silent = true, desc = "Close current/last focused terminal" })

vim.keymap.set("n", "<leader>tn", function()
    require("toggleterm").move_to_next()
end, { noremap = true, silent = true, desc = "Next terminal tab" })

vim.keymap.set("n", "<leader>tp", function()
    require("toggleterm").move_to_prev()
end, { noremap = true, silent = true, desc = "Previous terminal tab" })

vim.cmd([[
  autocmd TermOpen * startinsert
]])
