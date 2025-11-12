local cmp = require("cmp")
local luasnip = require("luasnip")

-- friendly-snippetsを読み込むが、"react"に関するスニペットだけは完全に無視する
require("luasnip.loaders.from_vscode").lazy_load({ exclude = { "react" } })

-- あなたの自作スニペットを読み込む
require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })

luasnip.add_snippets("javascript", {
    luasnip.snippet("clg", {
        luasnip.text_node("console.log("),
        luasnip.insert_node(1),
        luasnip.text_node(");"),
    }),
})

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),

        ["<Space>"] = cmp.mapping(function(fallback)
            if vim.fn["skkeleton#is_enabled"]() == 1 then
                vim.fn["skkeleton#map#henkan"]()
            else
                fallback()
            end
        end, { "i", "s", "c" }),
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
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
    }),
    sources = cmp.config.sources({
        { name = "luasnip", keyword_length = 1 },
        { name = "nvim_lsp", keyword_length = 1 },
        { name = "skkeleton", keyword_length = 1 },
    }, {
        { name = "buffer" },
        { name = "path" },
    }),
})
