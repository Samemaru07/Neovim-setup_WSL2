require("trouble").setup({
    position = "bottom",
    height = 12,
    icons = {
        indent = { top = "│ ", middle = "├╴", last = "└╴", fold_open = " ", fold_closed = " ", ws = "│ " },
        folder_closed = " ",
        folder_open = " ",
        kinds = { Error = " ", Warning = " ", Hint = " ", Information = " " },
    },
    padding = true,
    multiline = false,
    group = true,
    use_diagnostic_signs = true,
    action_keys = { jump = {}, jump_close = {} },
})

-- Trouble トグル → Normal 限定で OK
vim.keymap.set("n", "<leader>m", function()
    local trouble = require("trouble")
    if trouble.is_open() then
        trouble.close()
    else
        trouble.open("diagnostics")
    end
end, { noremap = true, silent = true, desc = "Toggle Trouble diagnostics" })
