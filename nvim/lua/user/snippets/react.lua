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

  -- Console log
  s("cl", {
    t('console.log('), i(1), t(');'),
  }),

  -- Console log with label
  s("cll", {
    t("console.log('"), i(1, 'label'), t("': "), t(', '), i(2), t(');'),
  }),
})

-- Also add to javascriptreact
ls.add_snippets("javascriptreact", ls.get_snippets("typescriptreact"))
