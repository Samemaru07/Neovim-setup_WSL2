local null_ls = require("null-ls")

-- UPDATE 文専用フォーマッタ
local update_formatter = {
    name = "update_sql_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, "\n")

            -- 大文字小文字を気にせず UPDATE ... SET ... を検出
            local update_part, where_part = sql:match("^(.-)%s+[Ww][Hh][Ee][Rr][Ee](.*)$")
            local body = update_part or sql
            local where_clause = where_part and ("WHERE" .. where_part) or ""

            -- UPDATE とテーブル名を分ける
            body = body:gsub("^[Uu][Pp][Dd][Aa][Tt][Ee]%s+([%w_]+)", function(tbl)
                return "UPDATE\n    " .. tbl
            end)

            -- SET 以降を処理（カンマ区切りで改行＋インデント）
            body = body:gsub("[Ss][Ee][Tt]%s+(.*)", function(set_clause)
                local parts = {}
                for col in set_clause:gmatch("[^,]+") do
                    table.insert(parts, "    " .. vim.trim(col))
                end
                return "SET\n" .. table.concat(parts, ",\n")
            end)

            -- WHERE 句があれば末尾に追加
            local formatted = body
            if where_clause ~= "" then
                formatted = formatted .. "\n" .. where_clause
            end

            return vim.split(formatted, "\n")
        end,
    },
}

null_ls.setup({
    sources = {
        update_formatter,
        -- 他のフォーマッタ/リンタもここに追加可能
    },
})
