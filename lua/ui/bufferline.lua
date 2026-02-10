local bufferline = require("bufferline")

bufferline.setup({
    options = {
        mode = "buffers",
        numbers = "none",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
        separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        offsets = {
            {
                filetype = "NvimTree",
                text = "エクスプローラ",
                text_align = "center",
                separator = true,
            },
        },
        hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
        },
        indicator = {
            style = "icon",
            icon = "▎",
        },
    },
})
