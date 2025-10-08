local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })

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
            require("luasnip").lsp_expand(args.body)
            vim.defer_fn(function()
                vim.cmd("doautocmd User TreesitterBufPost")
            end, 10)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_selected_entry() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
                    vim.defer_fn(function()
                        vim.cmd("doautocmd User TreesitterBufPost")
                    end, 10)
                else
                    fallback()
                end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ select = true }),
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
        end, { "i", "s" })
    }),
-- ... (これ以降も変更なし) ...
    sources = cmp.config.sources({
        { name = "nvim_lsp", keyword_length = 1 },
        { name = "luasnip",  keyword_length = 1 },
    }, {
        { name = "buffer" },
        { name = "path" }
    })
})
