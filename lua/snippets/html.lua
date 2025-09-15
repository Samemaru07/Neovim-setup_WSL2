local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	-- 基本ブロック
	s("div", { t("<div>"), i(1), t("</div>") }),
	s("span", { t("<span>"), i(1), t("</span>") }),
	s("p", { t("<p>"), i(1), t("</p>") }),
	s("a", { t('<a href="'), i(1), t('">'), i(2), t("</a>") }),

	-- 見出し
	s("h1", { t("<h1>"), i(1), t("</h1>") }),
	s("h2", { t("<h2>"), i(1), t("</h2>") }),
	s("h3", { t("<h3>"), i(1), t("</h3>") }),
	s("h4", { t("<h4>"), i(1), t("</h4>") }),
	s("h5", { t("<h5>"), i(1), t("</h5>") }),
	s("h6", { t("<h6>"), i(1), t("</h6>") }),

	-- リスト
	s("ul", { t("<ul>"), i(1), t("</ul>") }),
	s("ol", { t("<ol>"), i(1), t("</ol>") }),
	s("li", { t("<li>"), i(1), t("</li>") }),

	-- 画像・メディア
	s("img", { t('<img src="'), i(1), t('" alt="'), i(2), t('">') }),
	s("video", { t('<video src="'), i(1), t('" controls>'), i(2), t("</video>") }),
	s("audio", { t('<audio src="'), i(1), t('" controls>'), i(2), t("</audio>") }),

	-- フォーム系
	s("form", { t('<form action="'), i(1), t('" method="'), i(2, "post"), t('">'), i(3), t("</form>") }),
	s("input", { t('<input type="'), i(1, "text"), t('" name="'), i(2), t('">') }),
	s("button", { t("<button>"), i(1), t("</button>") }),
	s("label", { t('<label for="'), i(1), t('">'), i(2), t("</label>") }),
	s("textarea", { t("<textarea>"), i(1), t("</textarea>") }),

	-- テーブル
	s("table", { t("<table>"), i(1), t("</table>") }),
	s("tr", { t("<tr>"), i(1), t("</tr>") }),
	s("td", { t("<td>"), i(1), t("</td>") }),
	s("th", { t("<th>"), i(1), t("</th>") }),

	-- セマンティックタグ
	s("header", { t("<header>"), i(1), t("</header>") }),
	s("footer", { t("<footer>"), i(1), t("</footer>") }),
	s("main", { t("<main>"), i(1), t("</main>") }),
	s("section", { t("<section>"), i(1), t("</section>") }),
	s("article", { t("<article>"), i(1), t("</article>") }),
	s("nav", { t("<nav>"), i(1), t("</nav>") }),
}

