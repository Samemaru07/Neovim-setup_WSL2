local null_ls = require("null-ls")

local sql_formatter = {
    name = "simple_sql_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, "\n")
            sql = vim.trim(sql)

            sql = sql:gsub("UPDATE%s+(%w+)%s+SET", "UPDATE\n    %1\nSET")

            sql = sql:gsub("DELETE%s+FROM%s+(%w+)", "DELETE\nFROM\n    %1")

            sql = sql:gsub("%s+WHERE%s+", "\nWHERE\n    ")

            return { { text = sql } }
        end
    }
}

local pg_format = null_ls.builtins.formatting.pg_format.with({
    to_stdin = true,
    extra_args = {
        "--keyword-case", "2",
        "--spaces", "4"
    }
})

null_ls.setup({
    sources = {
        sql_formatter
    }
})
