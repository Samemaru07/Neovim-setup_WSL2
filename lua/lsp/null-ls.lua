local null_ls = require("null-ls")

local update_sql_formatter = {
    name = "update_sql_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, " ")
            sql = vim.trim(sql)

            -- normalize 空白を最低1個にそろえる
            sql = sql:gsub("%s+", " ")

            -- UPDATE ... SET の部分をキャプチャ
            sql = sql:gsub("(?i)update%s+([%w_]+)%s+set", function(tbl)
                return "UPDATE\n    " .. tbl .. "\nSET"
            end)

            return { { text = sql } }
        end,
    },
}

null_ls.setup({
    sources = {
        update_sql_formatter,
    },
})
