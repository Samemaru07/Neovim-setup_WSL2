local null_ls = require("null-ls")

local update_sql_formatter = {
    name = "update_sql_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, "\n")
            sql = vim.trim(sql)

            sql = sql:gsub("[Uu][Pp][Dd][Aa][Tt][Ee]", "UPDATE")
            sql = sql:gsub("[Ss][Ee][Tt]", "SET")

            sql = sql:gsub("UPDATE%s*(%w+)%s*SET", "UPDATE\n    %1\nSET")

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
        end
    }
}

local delete_sql_formatter = {
    name = "delete_sql_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, "\n")
            sql = vim.trim(sql)

            sql = sql:gsub("[Dd][Ee][Ll][Ee][Tt][Ee]", "DELETE")
            sql = sql:gsub("[Ff][Rr][Oo][Mm]", "FROM")

            sql = sql:gsub("DELETE%s*FROM%s*(%w+)", "DELETE\nFROM\n    %1")

            local before_where, where_clause = sql:match("^(.-)(WHERE.*)$")
            if before_where then
                before_where = before_where
                    :gsub("FROM%s*(.-)%s*$", function(tbl)
                        return "FROM\n    " .. vim.trim(tbl)
                    end)
                sql = before_where .. "\n" .. where_clause
                    :gsub("WHERE%s*(.-)$", function(condition)
                        local parts = {}
                        for part in condition:gmatch("[^,]+") do
                            table.insert(parts, "    " .. vim.trim(part))
                        end
                        return "WHERE\n" .. table.concat(parts, "\n")
                    end)
            else
                sql = sql
                    :gsub("FROM%s*(.-)$", function(tbl)
                        return "FROM\n    " .. vim.trim(tbl)
                    end)
            end

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
        update_sql_formatter,
        delete_sql_formatter,
        pg_format
    }
})
