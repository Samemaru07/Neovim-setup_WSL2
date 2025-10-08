local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s("myrafce", {
        t("const "), i(1, "Component"), t(" = () => {"),
        t({ "", "    return (" }),
        t({ "", "        <div>" }),
        t({ "", "            " }), i(2),
        t({ "", "        </div>" }),
        t({ "", "    );" }),
        t({ "", "};" }),
        t({ "", "", "export default " }), i(1)
    }),

    s("us", {
        t("const ["), i(1, "state"), t(", set"), i(2, "State"),
        t("] = useState("), i(3, "initialValue"), t(")")
    }),

    s("ue", {
        t("useEffect(() => {"),
        t({ "", "    " }), i(1, "// effect"),
        t({ "", "}, [" }), i(2), t("])")
    }),

    s("div", { t("<div>"), i(1), t("</div>") }),
    s("span", { t("<span>"), i(1), t("</span>") }),
    s("btn", { t('<button onClick={() => '), i(1, "handleClick"), t("}>"), i(2, "Click"), t("</button>") }),
    s("in",
        { t('<input type="'), i(1, "text"), t('" value={'), i(2, "value"), t("} onChange={"), i(3, "handleChange"), t(
        "} />") }),
    s("img", { t('<img src="'), i(1), t('" alt="'), i(2), t('" />') }),
    s("map", {
        t("{"), i(1, "items"), t(".map(("), i(2, "item"), t(", index) => ("),
        t({ "", "    <div key={index}>" }),
        i(3, "{item}"),
        t({ "", "    </div>" }),
        t("))}")
    })
}
