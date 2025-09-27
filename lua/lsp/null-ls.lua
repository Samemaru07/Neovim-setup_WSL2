local null_ls = require("null-ls")

local update_sql_formatter = {
    name = "update_sql_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, "\n")
            sql = vim.trim(sql)

            -- UPDATE を単語境界で検知
            sql = sql:gsub("%f[%w][Uu][Pp][Dd][Aa][Tt][Ee]%f[%W]", "UPDATE")
            -- SET を単語境界で検知
            sql = sql:gsub("%f[%w][Ss][Ee][Tt]%f[%W]", "SET")

            -- UPDATE <table> SET を縦に揃える
            sql = sql:gsub("UPDATE%s+(%w+)%s+SET", "UPDATE\n    %1\nSET")

            return { { text = sql } }
        end,
    },
}

null_ls.setup({
    sources = {
        update_sql_formatter,
    },
})
