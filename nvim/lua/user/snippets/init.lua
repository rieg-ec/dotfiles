-- Custom snippets configuration
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- Load snippets from separate files
require("user.snippets.react")
require("user.snippets.javascript")
require("user.snippets.html")

