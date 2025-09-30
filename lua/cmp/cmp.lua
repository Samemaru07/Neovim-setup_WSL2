local cmp = require("cmp")
local luasnip = require("luasnip")

-- lazy.nvim 経由で friendly-snippets を強制ロード
require("luasnip.loaders.from_vscode").lazy_load({
    paths = { "C:/Users/nakayama/AppData/Local/nvim-data/lazy/friendly-snippets" }
})

-- JS 用 clg スニペットを直接追加
luasnip.add_snippets("javascript", {
    luasnip.snippet("clg", {
        luasnip.text_node("console.log("),
        luasnip.insert_node(1),
        luasnip.text_node(");"),
    })
})

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp", keyword_length = 1 }, -- 型補完
        { name = "luasnip",  keyword_length = 1 }, -- スニペット補完
    }, {
        { name = "buffer" },
        { name = "path" }
    })
})
