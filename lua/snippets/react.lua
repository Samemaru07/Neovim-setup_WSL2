local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	-- React コンポーネント (関数)
	s("rfc", {
		t("const "), i(1, "Component"), t(" = () => {"),
		t({ "", "  return (" }),
		t({ "", "    " }), i(2, "<div></div>"),
		t({ "", "  );", "" }),
		t("};"),
		t({ "", "", "export default " }), i(1),
	}),

	-- React useState
	s("us", {
		t("const ["), i(1, "state"), t(", set"), i(2, "State"),
		t("] = useState("), i(3, "initialValue"), t(")"),
	}),

	-- useEffect
	s("ue", {
		t("useEffect(() => {"),
		t({ "", "  " }), i(1, "// effect"),
		t({ "", "}, [" }), i(2), t("])"),
	}),

	-- div
	s("div", { t("<div>"), i(1), t("</div>") }),
	-- span
	s("span", { t("<span>"), i(1), t("</span>") }),
	-- button
	s("btn", { t('<button onClick={() => '), i(1, "handleClick"), t("}>"), i(2, "Click"), t("</button>") }),
	-- input
	s("in", { t('<input type="'), i(1, "text"), t('" value={'), i(2, "value"), t("} onChange={"), i(3, "handleChange"), t("} />") }),
	-- img
	s("img", { t('<img src="'), i(1), t('" alt="'), i(2), t('" />') }),
	-- map
	s("map", {
		t("{"), i(1, "items"), t(".map(("), i(2, "item"), t(", index) => ("),
		t({ "", "  <div key={index}>" }),
		i(3, "{item}"),
		t({ "", "  </div>" }),
		t("))}"),
	}),
}

