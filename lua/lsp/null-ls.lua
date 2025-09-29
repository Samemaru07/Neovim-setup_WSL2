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

            local lower = sql:lower()
            if not lower:match("^%s*delete") then
                return { { text = sql } }
            end

            local has_semicolon = false
            if sql:match(";%s*$") then
                has_semicolon = true
                sql = sql:gsub(";%s*$", "")
                sql = vim.trim(sql)
            end

            local l = sql:lower()
            local delete_s, delete_e = l:find("%f[%a]delete%f[%A]")
            local from_s, from_e = l:find("%f[%a]from%f[%A]", (delete_e or 1) + 1)
            local where_s, where_e = nil, nil
            if from_e then
                where_s, where_e = l:find("%f[%a]where%f[%A]", from_e + 1)
            end

            local tables_part
            if from_e then
                if where_s then
                    tables_part = sql:sub(from_e + 1, where_s - 1)
                else
                    tables_part = sql:sub(from_e + 1)
                end
            else
                return { { text = sql .. (has_semicolon and ";" or "") } }
            end

            tables_part = vim.trim(tables_part)

            local tables = {}
            for t in tables_part:gmatch("([^,]+)") do
                t = vim.trim(t)
                if #t > 0 then
                    table.insert(tables, t)
                end
            end

            local where_block = nil
            if where_s then
                where_block = sql:sub(where_s)
                local conds = where_block:gsub("^[Ww][Hh][Ee][Rr][Ee]%s*", "")
                conds = conds:gsub("%s+[Aa][Nn][Dd]%s+", "\nAND ")
                conds = conds:gsub("%s+[Oo][Rr]%s+", "\nOR ")
                local cond_lines = {}
                for line in conds:gmatch("[^\n]+") do
                    table.insert(cond_lines, "    " .. vim.trim(line))
                end
                where_block = "WHERE\n" .. table.concat(cond_lines, "\n")
            end

            local out_lines = {}
            table.insert(out_lines, "DELETE")
            table.insert(out_lines, "FROM")
            for i, t in ipairs(tables) do
                local suffix = (i < #tables) and "," or ""
                table.insert(out_lines, "    " .. t .. suffix)
            end

            if where_block then
                table.insert(out_lines, where_block)
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
