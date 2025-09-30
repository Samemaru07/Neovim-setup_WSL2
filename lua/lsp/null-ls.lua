local null_ls = require("null-ls")

local pg_format = null_ls.builtins.formatting.pg_format.with({
    to_stdin = true,
    filetypes = { "sql", "pgsql" },
    extra_args = {
        "--format", "text",
        "--no-rcfile",
        "--keyword-case", "2",
        "--type-case", "2",
        "--spaces", "4"
    }
})

null_ls.setup({
    debug = true,
    sources = { pg_format }
})
