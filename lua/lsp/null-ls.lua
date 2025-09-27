local null_ls = require("null-ls")

-- 自作: UPDATE/SET 整形
local update_sql_formatter = {
    name = "update_sql_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, "\n")
            sql = vim.trim(sql)

            -- normalize: 大文字統一
            sql = sql:gsub("[Uu][Pp][Dd][Aa][Tt][Ee]", "UPDATE")
            sql = sql:gsub("[Ss][Ee][Tt]", "SET")

            -- UPDATE <table> SET → 縦揃え
            sql = sql:gsub("UPDATE%s*(%w+)%s*SET", "UPDATE\n    %1\nSET")

            -- SET の後ろを改行してインデント
            local before_where, where_clause = sql:match("^(.-)(WHERE.*)$")
            if before_where then
                before_where = before_where
                    :gsub("SET%s*(.-)%s*$", function(assignments)
                        local parts = {}
                        for part in assignments:gmatch("[^,]+") do
                            table.insert(parts, "    " .. vim.trim(part))
                        end
                        return "SET\n" .. table.concat(parts, ",\n")
                    end)
                sql = before_where .. "\n" .. where_clause
            else
                sql = sql
                    :gsub("SET%s*(.-)$", function(assignments)
                        local parts = {}
                        for part in assignments:gmatch("[^,]+") do
                            table.insert(parts, "    " .. vim.trim(part))
                        end
                        return "SET\n" .. table.concat(parts, ",\n")
                    end)
            end

            return { { text = sql } }
        end,
    },
}

-- pgFormatter を併用
local pg_format = null_ls.builtins.formatting.pg_format.with({
    to_stdin = true,
    extra_args = {
        "--keyword-case", "upper",
        "--spaces", "4",
    },
})

null_ls.setup({
    sources = {
        update_sql_formatter,
        pg_format,
    },
})
