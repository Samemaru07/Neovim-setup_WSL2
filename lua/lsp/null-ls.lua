local null_ls = require("null-ls")

local update_sql_formatter = {
    name = "update_sql_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, "\n")
            sql = vim.trim(sql)

            -- normalize: UPDATE / SET を必ず大文字に
            sql = sql:gsub("[Uu][Pp][Dd][Aa][Tt][Ee]", "UPDATE")
            sql = sql:gsub("[Ss][Ee][Tt]", "SET")

            -- UPDATE <table> SET → 改行揃え
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
