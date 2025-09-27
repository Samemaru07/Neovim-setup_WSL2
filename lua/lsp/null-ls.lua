local null_ls = require("null-ls")

local update_sql_formatter = {
    name = "update_sql_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, "\n")
            sql = vim.trim(sql)

            -- normalize: 小文字も大文字も UPDATE/SET に統一
            sql = sql:gsub("[Uu][Pp][Dd][Aa][Tt][Ee]", "UPDATE")
            sql = sql:gsub("[Ss][Ee][Tt]", "SET")

            -- UPDATE <table> SET → 改行揃え
            -- Lua の %s は「スペース1文字だけ」なので、複数対応に [ \t\r\n]+ を直接書けない
            -- → 代わりに %s* で「0個以上」にする
            sql = sql:gsub("UPDATE%s*(%w+)%s*SET", "UPDATE\n    %1\nSET")

            return { { text = sql } }
        end,
    },
}

null_ls.setup({
    sources = {
        update_sql_formatter,
    },
})
