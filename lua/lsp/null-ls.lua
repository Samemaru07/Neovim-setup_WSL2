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
    method = require("null-ls").methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, "\n")
            sql = vim.trim(sql)

            if not sql:lower():match("^delete") then
                return { { text = sql } }
            end

            local has_semicolon = sql:match(";%s*$")
            sql = sql:gsub(";%s*$", "")

            local delete_kw, from_kw, rest = sql:match("^(%s*[Dd][Ee][Ll][Ee][Tt][Ee])%s+([Ff][Rr][Oo][Mm])%s+(.+)$")
            if not delete_kw then
                return { { text = sql .. (has_semicolon or "") } }
            end

            local tables_part, where_part = rest:match("^(.-)%s+([Ww][Hh][Ee][Rr][Ee].*)$")
            if not tables_part then
                tables_part = rest
            end

            local tables = {}
            for t in tables_part:gmatch("([^,]+)") do
                t = vim.trim(t)
                if #t > 0 then
                    table.insert(tables, "    " .. t .. ",")
                end
            end
            if #tables > 0 then
                tables[#tables] = tables[#tables]:gsub(",$", "")
            end

            local out_lines = {}
            table.insert(out_lines, "DELETE")
            table.insert(out_lines, "FROM")
            for _, t in ipairs(tables) do
                table.insert(out_lines, t)
            end
            if where_part then
                table.insert(out_lines, where_part:gsub("^%s*", function()
                    return "WHERE\n    "
                end))
            end

            local out = table.concat(out_lines, "\n")
            if has_semicolon then
                out = out .. ";"
            end

            return { { text = out } }
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
