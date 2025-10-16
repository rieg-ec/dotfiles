-- JavaScript/TypeScript snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("all", {
  -- Arrow function
  s("af", {
    t('('), i(1), t(') => '), i(2),
  }),

  -- Async arrow function  
  s("aaf", {
    t('async ('), i(1), t(') => '), i(2),
  }),

  -- Try catch
  s("try", {
    t({'try {', '  '}), i(1),
    t({'', '} catch (error) {', '  console.error(error);', '  '}), i(2),
    t({'', '}'}),
  }),

  -- Import
  s("imp", {
    t('import { '), i(1), t(' } from "'), i(2), t('";'),
  }),

  -- Import default
  s("impd", {
    t('import '), i(1), t(' from "'), i(2), t('";'),
  }),

  -- Export default
  s("expd", {
    t('export default '), i(1), t(';'),
  }),

  -- Destructuring
  s("dest", {
    t('const { '), i(1), t(' } = '), i(2), t(';'),
  }),

  -- Console log
  s("cl", {
    t('console.log('), i(1), t(');'),
  }),

  -- Console log with label
  s("cll", {
    t("console.log('"), i(1, 'label'), t("': ", ', '), i(2), t(');'),
  }),
})
