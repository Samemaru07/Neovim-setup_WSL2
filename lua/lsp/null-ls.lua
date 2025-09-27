local null_ls = require("null-ls")

local update_formatter = {
    name = "update_sql_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            -- 入力SQLを1行にまとめてトリム
            local sql = table.concat(params.content, " ")
            sql = vim.trim(sql)

            -- 小文字化で検索位置を安全に取る
            local lower_sql = sql:lower()

            local update_pos = lower_sql:find("update")
            local set_pos = lower_sql:find(" set ")
            local where_pos = lower_sql:find(" where ")

            if not (update_pos and set_pos) then
                return { { text = sql } }
            end

            -- UPDATE のあとから SET の直前までがテーブル名
            local table_name = vim.trim(sql:sub(update_pos + #"update", set_pos - 1))

            local set_clause
            local where_clause = nil

            if where_pos then
                set_clause = vim.trim(sql:sub(set_pos + #" set ", where_pos - 1))
                where_clause = vim.trim(sql:sub(where_pos + #" where "))
            else
                set_clause = vim.trim(sql:sub(set_pos + #" set "))
            end

            -- SET の中をカンマで分割
            local set_lines = {}
            for col in set_clause:gmatch("[^,]+") do
                table.insert(set_lines, "    " .. vim.trim(col))
            end

            -- 再構築
            local result = {}
            table.insert(result, "UPDATE")
            table.insert(result, "    " .. table_name)
            table.insert(result, "SET")
            table.insert(result, table.concat(set_lines, ",\n"))
            if where_clause then
                table.insert(result, "WHERE")
                table.insert(result, "    " .. where_clause)
            end

            return {
                {
                    text = table.concat(result, "\n"),
                },
            }
        end,
    },
}

null_ls.setup({
    sources = {
        update_formatter,
    },
})
