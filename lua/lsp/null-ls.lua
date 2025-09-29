local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")

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
    method = methods.FORMATTING,
    filetypes = { "sql" },
    generator = helpers.formatter_factory({
        command = "pg_format",
        args = { "--keyword-case", "2", "--spaces", "4" },
        to_stdin = true,
        transform = function(text)
            text = text:gsub("DELETE%s+FROM", "DELETE\nFROM")
            text = text:gsub("FROM%s+([^Ww;]+)", function(tables)
                local parts = {}
                for part in tables:gmatch("[^,]+") do
                    table.insert(parts, "    " .. vim.trim(part))
                end
                return "FROM\n" .. table.concat(parts, ",\n")
            end)
            text = text:gsub("[Ww][Hh][Ee][Rr][Ee]%s+(.+)", function(condition)
                return "WHERE\n    " .. vim.trim(condition)
            end)
            return text
        end
    })
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
