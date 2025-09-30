require("nvim-tree").setup({
    view = {
        side = "left",
        width = 25
    },
    renderer = {
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = false
            }
        },
        indent_markers = {
            enable = false
        }
    },
    filters = {
        dotfiles = false
    },
    git = {
        enable = false
    },
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = true
    }
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "NvimTree_*",
    callback = function()
        if vim.fn.mode() == "i" then
            vim.cmd("stopinsert")
        end
        vim.api.nvim_buf_set_name(0, "エクスプローラ")
    end
})

vim.cmd [[
highlight NvimTreeNormal guibg=NONE
highlight NvimTreeVertSplit guibg=NONE
highlight NvimTreeEndOfBuffer guibg=NONE
highlight NvimTreeStatusLine guibg=NONE
highlight NvimTreeStatusLineNC guibg=NONE
]]
