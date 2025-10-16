-- HTML/Vue snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Helper function to create HTML tag snippets
local function html_tag(tag)
  return s(tag, {
    t('<' .. tag .. ' class="'), i(1), t('">'),
    i(2),
    t('</' .. tag .. '>'),
  })
end

-- Helper function for self-closing tags
local function html_tag_self_closing(tag)
  return s(tag, {
    t('<' .. tag .. ' class="'), i(1), t('" />'),
  })
end

-- Common HTML tags
local html_tags = {
  -- Text content
  "p", "span", "div", "h1", "h2", "h3", "h4", "h5", "h6",
  "strong", "em", "small", "mark", "del", "ins", "sub", "sup",
  
  -- Lists
  "ul", "ol", "li", "dl", "dt", "dd",
  
  -- Links and media
  "a", "button",
  
  -- Forms
  "form", "label", "select", "option", "textarea",
  
  -- Sections
  "header", "nav", "main", "section", "article", "aside", "footer",
  
  -- Tables
  "table", "thead", "tbody", "tfoot", "tr", "th", "td",
  
  -- Other
  "blockquote", "pre", "code", "figure", "figcaption",
}

-- Self-closing tags
local self_closing_tags = {
  "input", "img", "br", "hr", "meta", "link",
}

-- Build snippet table for HTML files
local html_snippets = {}

-- Add regular tags
for _, tag in ipairs(html_tags) do
  table.insert(html_snippets, html_tag(tag))
end

-- Add self-closing tags
for _, tag in ipairs(self_closing_tags) do
  table.insert(html_snippets, html_tag_self_closing(tag))
end

-- Add some special cases
table.insert(html_snippets, s("input", {
  t('<input type="'), i(1, 'text'), t('" class="'), i(2), t('" />'),
}))

table.insert(html_snippets, s("img", {
  t('<img src="'), i(1), t('" alt="'), i(2), t('" class="'), i(3), t('" />'),
}))

table.insert(html_snippets, s("a", {
  t('<a href="'), i(1), t('" class="'), i(2), t('">'),
  i(3),
  t('</a>'),
}))

table.insert(html_snippets, s("button", {
  t('<button type="'), i(1, 'button'), t('" class="'), i(2), t('">'),
  i(3),
  t('</button>'),
}))

-- Add to HTML filetype
ls.add_snippets("html", html_snippets)

-- Add to Vue filetype
ls.add_snippets("vue", html_snippets)

-- Also add Vue-specific snippets
ls.add_snippets("vue", {
  -- v-for
  s("vfor", {
    t('v-for="'), i(1, 'item'), t(' in '), i(2, 'items'), t('" :key="'), i(3, 'item.id'), t('"'),
  }),
  
  -- v-if
  s("vif", {
    t('v-if="'), i(1), t('"'),
  }),
  
  -- v-else-if
  s("velif", {
    t('v-else-if="'), i(1), t('"'),
  }),
  
  -- v-else
  s("velse", {
    t('v-else'),
  }),
  
  -- v-model
  s("vmodel", {
    t('v-model="'), i(1), t('"'),
  }),
  
  -- @click
  s("@click", {
    t('@click="'), i(1), t('"'),
  }),
  
  -- Vue 3 component
  s("vuecomp", {
    t({'<script setup lang="ts">',
       'import { ref } from "vue";',
       '',
       ''}), i(1),
    t({'',
       '</script>',
       '',
       '<template>',
       '  <div class="'}), i(2), t({'">',
       '    '}), i(3),
    t({'',
       '  </div>',
       '</template>',
       '',
       '<style scoped>',
       ''}), i(4),
    t({'',
       '</style>'}),
  }),
})

