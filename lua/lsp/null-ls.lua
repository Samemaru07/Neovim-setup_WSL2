local null_ls = require("null-ls")

local simple_update_formatter = {
    name = "simple_update_formatter",
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = {
        fn = function(params)
            local sql = table.concat(params.content, " ")
            sql = vim.trim(sql)

            -- 大文字小文字区別なしで位置を取る
            local lower_sql = sql:lower()
            local update_pos = lower_sql:find("update")
            local set_pos = lower_sql:find(" set ")

            if not (update_pos and set_pos) then
                return { { text = sql } } -- update or set が無ければそのまま
            end

            -- UPDATE と SET の間をテーブル名部分として抜き出す
            local table_name = vim.trim(sql:sub(update_pos + #"update", set_pos - 1))
            local after_set = sql:sub(set_pos + 1) -- "set" 以降そのまま

            -- 整形結果
            local result = table.concat({
                "UPDATE",
                "    " .. table_name,
                "SET" .. after_set:sub(4), -- "set" を削って残りを付与
            }, "\n")

            return { { text = result } }
        end,
    },
}

null_ls.setup({
    sources = {
        simple_update_formatter,
    },
})
