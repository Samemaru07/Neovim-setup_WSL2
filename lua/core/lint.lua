local lint = require("lint")

lint.linters_by_ft = {
    verilog = { "iverilog" },
    vhdl = { "ghdl" }
}

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function()
        require("lint").try_lint()
    end
})
