local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local function get_component_name_from_filename()
    local filename = vim.fn.expand('%:t:r')
    filename = filename:gsub("[-_](%w)", string.upper)
    return filename:gsub("^%l", string.upper)
end

return {
    s("rafce", {
        t("function "),
        i(1, get_component_name_from_filename()),
        t("() {"),
        t({ "", "    return (" }),
        t({ "", "        <>" }),
        t({ "", "            " }),
        i(0),
        t({ "", "        </>" }),
        t({ "", "    );" }),
        t({ "", "}" }),
        t({ "", "", "export default " }),
        i(1)
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
    s("p", { t("<p>"), i(1), t("</p>") }),
    s("h1", { t("<h1>"), i(1), t("</h1>") }),
    s("h2", { t("<h2>"), i(1), t("</h2>") }),
    s("h3", { t("<h3>"), i(1), t("</h3>") }),
    s("h4", { t("<h4>"), i(1), t("</h4>") }),
    s("h5", { t("<h5>"), i(1), t("</h5>") }),
    s("h6", { t("<h6>"), i(1), t("</h6>") }),
    s("span", { t("<span>"), i(1), t("</span>") }),
    s("a", { t('<a href="'), i(1), t('">'), i(2), t("</a>") }),
    s("ul", { t("<ul>"), i(1), t("</ul>") }),
    s("ol", { t("<ol>"), i(1), t("</ol>") }),
    s("li", { t("<li>"), i(1), t("</li>") }),
    s("img", { t('<img src="'), i(1), t('" alt="'), i(2), t('" />') }),
    s("video", { t('<video src="'), i(1), t('" controls>'), i(2), t("</video>") }),
    s("audio", { t('<audio src="'), i(1), t('" controls>'), i(2), t("</audio>") }),
    s("form", { t('<form>'), i(1), t("</form>") }),
    s("input", { t('<input type="'), i(1, "text"), t('" name="'), i(2), t('" />') }),
    s("in", { t('<input type="'), i(1, "text"), t('" name="'), i(2), t('" />') }),
    s("button", { t("<button>"), i(1), t("</button>") }),
    s("btn", { t('<button onClick={() => {'), i(1), t('}}>'), i(2), t("</button>") }),
    s("label", { t('<label htmlFor="'), i(1), t('">'), i(2), t("</label>") }),
    s("textarea", { t("<textarea>"), i(1), t("</textarea>") }),
    s("table", { t("<table>"), i(1), t("</table>") }),
    s("tr", { t("<tr>"), i(1), t("</tr>") }),
    s("td", { t("<td>"), i(1), t("</td>") }),
    s("th", { t("<th>"), i(1), t("</th>") }),
    s("header", { t("<header>"), i(1), t("</header>") }),
    s("footer", { t("<footer>"), i(1), t("</footer>") }),
    s("main", { t("<main>"), i(1), t("</main>") }),
    s("section", { t("<section>"), i(1), t("</section>") }),
    s("article", { t("<article>"), i(1), t("</article>") }),
    s("nav", { t("<nav>"), i(1), t("</nav>") }),
    s("map", {
        t("{"), i(1, "items"), t(".map((item) => ("),
        t({ "", "    <div key={item.id}>" }),
        t({ "", "        " }), i(2, "{item.name}"),
        t({ "", "    </div>" }),
        t({ "", "))}" })
    })
}
