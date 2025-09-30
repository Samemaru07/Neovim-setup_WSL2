local bufferline = require("bufferline")

bufferline.setup({
    options = {
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        separator_style = "slant"
    }
})
