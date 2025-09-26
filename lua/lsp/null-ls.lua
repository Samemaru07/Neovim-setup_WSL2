local null_ls = require("null-ls");

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.pg_format.with({
            extra_args = {
                "--keyword-case", "upper",
                "--spaces", "4"
            }
        })
    }
})
