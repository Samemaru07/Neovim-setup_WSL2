vim.cmd [[
highlight Normal guibg=NONE
highlight NormalNC guibg=NONE
highlight NonText guibg=NONE
highlight EndOfBuffer guibg=NONE
highlight SignColumn guibg=NONE

highlight Indent1 guifg=#FF8FA1 gui=nocombine
highlight Indent2 guifg=#FFC27F gui=nocombine
highlight Indent3 guifg=#62C8C8 gui=nocombine
highlight Indent4 guifg=#7FD1A8 gui=nocombine
highlight Indent5 guifg=#A776B7 gui=nocombine
highlight Indent6 guifg=#FFB84D gui=nocombine
]]

require("ibl").setup({
    indent = {
        char = "│",
        highlight = {
            "Indent1",
            "Indent2",
            "Indent3",
            "Indent4",
            "Indent5",
            "Indent6"
        },
    },
    scope = {
        enabled = false
    }
})
