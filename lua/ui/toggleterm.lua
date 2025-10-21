local toggleterm = require("toggleterm")

toggleterm.setup({
    size = 8,
    direction = "horizontal",
    start_in_insert = true,
    close_on_exit = false,
    on_open = function(term)
        vim.api.nvim_buf_set_name(term.bufnr, "ターミナル #" .. term.count)
        vim.api.nvim_win_set_option(term.window, "winhighlight", "Normal:Normal")
    end,
})

vim.keymap.set("n", "<leader>t", function()
    require("toggleterm").toggle_command("horizontal")
end, { noremap = true, silent = true, desc = "Toggle horizontal terminal section" })

vim.keymap.set("n", "<leader>n", function()
    require("toggleterm").new_term({ cmd = "wsl.exe -e zsh", direction = "horizontal" })
end, { noremap = true, silent = true, desc = "New terminal tab" })

vim.keymap.set("n", "<leader>td", function()
    require("toggleterm").close()
end, { noremap = true, silent = true, desc = "Close current terminal tab" })

vim.keymap.set("n", "<leader>tn", function()
    require("toggleterm").move_to_next()
end, { noremap = true, silent = true, desc = "Next terminal tab" })

vim.keymap.set("n", "<leader>tp", function()
    require("toggleterm").move_to_prev()
end, { noremap = true, silent = true, desc = "Previous terminal tab" })

vim.cmd([[
  autocmd TermOpen * startinsert
]])
