-- React/JSX snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node

ls.add_snippets("typescriptreact", {
  -- View component
  s("View", {
    t('<View className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</View>"}),
  }),

  -- View self-closing
  s("Viewc", {
    t('<View className="'), i(1), t('" />'),
  }),

  -- className attribute
  s("className", {
    t('className="'), i(1), t('"'),
  }),

  -- Text component
  s("Text", {
    t('<Text className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</Text>"}),
  }),

  -- Text self-closing
  s("Textc", {
    t('<Text className="'), i(1), t('" />'),
  }),

  -- BaseText component
  s("BaseText", {
    t('<BaseText className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</BaseText>"}),
  }),

  -- BaseText self-closing
  s("BaseTextc", {
    t('<BaseText className="'), i(1), t('" />'),
  }),

  -- BaseButton component
  s("basebutton", {
    t({'<BaseButton', '  variant="'}), i(1, 'primary'), t('"'),
    t({'', '  text="'}), i(2), t('"'),
    t({'', '  className="'}), i(3), t('"'),
    t({'', '  onPress={() => '}), i(4), t('}'),
    t({'', '/>'}),
  }),

  -- useNavigation hook
  s("navigation", {
    t('const navigation = useNavigation<NativeStackNavigationProp<'), i(1), t('>>();'),
  }),

  -- TouchableOpacity
  s("TouchableOpacity", {
    t('<TouchableOpacity className="'), i(1), t('" onPress={'), i(2), t('}>'),
    t({"", "  "}), i(3),
    t({"", "</TouchableOpacity>"}),
  }),

  -- Pressable
  s("Pressable", {
    t('<Pressable className="'), i(1), t('" onPress={'), i(2), t('}>'),
    t({"", "  "}), i(3),
    t({"", "</Pressable>"}),
  }),

  -- ScrollView
  s("ScrollView", {
    t('<ScrollView className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</ScrollView>"}),
  }),

  -- SafeAreaView
  s("SafeAreaView", {
    t('<SafeAreaView className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</SafeAreaView>"}),
  }),

  -- onPress handler
  s("onPress", {
    t('onPress={'), i(1), t('}'),
  }),

  -- useState
  s("useState", {
    t('const ['), i(1, 'state'), t(', set'),
    ls.function_node(function(args)
      local name = args[1][1]
      if name == "" then return "State" end
      return name:sub(1,1):upper()..name:sub(2)
    end, {1}),
    t('] = useState('), i(2), t(');'),
  }),

  -- useEffect
  s("useEffect", {
    t({'useEffect(() => {', '  '}), i(1),
    t({'', '}, ['}), i(2), t(']);'),
  }),

  -- React component
  s("rfc", {
    t('export default function '), i(1, 'Component'), t({'() {', '  return (', '    <View className="'}),
    i(2), t({'">','      '}), i(3),
    t({'', '    </View>', '  );', '}'}),
  }),

  -- React Native component (uses filename as component name)
  s("rfcn", {
    t({'import { View } from "react-native";', '', 'export default function '}),
    ls.function_node(function()
      local filename = vim.fn.expand('%:t:r') -- Get filename without extension
      if filename == '' then
        return 'Component'
      end
      return filename
    end),
    t({'() {', '  return (', '    <View className="'}),
    i(1),
    t({'">','      '}), i(2),
    t({'', '    </View>', '  );', '}'}),
  }),

  -- Console log with label
  s("cll", {
    t("console.log('"), i(1, 'label'), t("': "), t(', '), i(2), t(');'),
  }),

  -- div tag
  s("div", {
    t('<div className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</div>"}),
  }),

  -- h1 tag
  s("h1", {
    t('<h1 className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</h1>"}),
  }),

  -- h2 tag
  s("h2", {
    t('<h2 className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</h2>"}),
  }),

  -- h3 tag
  s("h3", {
    t('<h3 className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</h3>"}),
  }),

  -- h4 tag
  s("h4", {
    t('<h4 className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</h4>"}),
  }),

  -- h5 tag
  s("h5", {
    t('<h5 className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</h5>"}),
  }),

  -- h6 tag
  s("h6", {
    t('<h6 className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</h6>"}),
  }),

  -- p tag
  s("p", {
    t('<p className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</p>"}),
  }),

  -- span tag
  s("span", {
    t('<span className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</span>"}),
  }),

  -- button tag
  s("button", {
    t('<button className="'), i(1), t('" onClick={'), i(2), t('}>'),
    t({"", "  "}), i(3),
    t({"", "</button>"}),
  }),

  -- self-closing button
  s("buttonc", {
    t('<button className="'), i(1), t('" onClick={'), i(2), t('} />'),
  }),

  -- a (anchor) tag
  s("a", {
    t('<a href="'), i(1), t('" className="'), i(2), t('">'),
    t({"", "  "}), i(3),
    t({"", "</a>"}),
  }),

  -- img tag
  s("img", {
    t('<img src="'), i(1), t('" alt="'), i(2), t('" className="'), i(3), t('" />'),
  }),

  -- input tag
  s("input", {
    t('<input type="'), i(1, 'text'), t('" className="'), i(2), t('" placeholder="'), i(3), t('" />'),
  }),

  -- textarea tag
  s("textarea", {
    t('<textarea className="'), i(1), t('" placeholder="'), i(2), t('" />'),
  }),

  -- form tag
  s("form", {
    t('<form className="'), i(1), t('" onSubmit={'), i(2), t('}>'),
    t({"", "  "}), i(3),
    t({"", "</form>"}),
  }),

  -- label tag
  s("label", {
    t('<label className="'), i(1), t('" htmlFor="'), i(2), t('">'),
    t({"", "  "}), i(3),
    t({"", "</label>"}),
  }),

  -- select tag
  s("select", {
    t('<select className="'), i(1), t('">'),
    t({"", "  <option>"}), i(2),
    t({"", "</option>", "</select>"}),
  }),

  -- option tag
  s("option", {
    t('<option value="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</option>"}),
  }),

  -- table tag
  s("table", {
    t('<table className="'), i(1), t('">'),
    t({"", "  <thead>", "    <tr>", "      <th>"}), i(2),
    t({"", "</th>", "    </tr>", "  </thead>", "  <tbody>", "    <tr>", "      <td>"}), i(3),
    t({"", "</td>", "    </tr>", "  </tbody>", "</table>"}),
  }),

  -- tr (table row) tag
  s("tr", {
    t('<tr className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</tr>"}),
  }),

  -- td (table data) tag
  s("td", {
    t('<td className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</td>"}),
  }),

  -- th (table header) tag
  s("th", {
    t('<th className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</th>"}),
  }),

  -- thead tag
  s("thead", {
    t('<thead className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</thead>"}),
  }),

  -- tbody tag
  s("tbody", {
    t('<tbody className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</tbody>"}),
  }),

  -- section tag
  s("section", {
    t('<section className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</section>"}),
  }),

  -- article tag
  s("article", {
    t('<article className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</article>"}),
  }),

  -- nav tag
  s("nav", {
    t('<nav className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</nav>"}),
  }),

  -- header tag
  s("header", {
    t('<header className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</header>"}),
  }),

  -- footer tag
  s("footer", {
    t('<footer className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</footer>"}),
  }),

  -- main tag
  s("main", {
    t('<main className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</main>"}),
  }),

  -- aside tag
  s("aside", {
    t('<aside className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</aside>"}),
  }),

  -- ul (unordered list) tag
  s("ul", {
    t('<ul className="'), i(1), t('">'),
    t({"", "  <li>"}), i(2),
    t({"", "</li>", "</ul>"}),
  }),

  -- ol (ordered list) tag
  s("ol", {
    t('<ol className="'), i(1), t('">'),
    t({"", "  <li>"}), i(2),
    t({"", "</li>", "</ol>"}),
  }),

  -- li (list item) tag
  s("li", {
    t('<li className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</li>"}),
  }),

  -- strong tag
  s("strong", {
    t('<strong className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</strong>"}),
  }),

  -- em tag
  s("em", {
    t('<em className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</em>"}),
  }),

  -- code tag
  s("code", {
    t('<code className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</code>"}),
  }),

  -- pre tag
  s("pre", {
    t('<pre className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</pre>"}),
  }),

  -- blockquote tag
  s("blockquote", {
    t('<blockquote className="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</blockquote>"}),
  }),

  -- hr (horizontal rule) tag
  s("hr", {
    t('<hr className="'), i(1), t('" />'),
  }),

  -- br (line break) tag
  s("br", {
    t('<br className="'), i(1), t('" />'),
  }),

  -- Console log
  s("cl", {
    t('console.log('), i(1), t(');'),
  }),
})

-- Also add to javascriptreact
ls.add_snippets("javascriptreact", ls.get_snippets("typescriptreact"))
