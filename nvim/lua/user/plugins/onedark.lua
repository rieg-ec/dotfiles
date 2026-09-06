local function theme_options(style)
    return {
        -- Main options --
        style = style, -- Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        -- Keep the dark theme blended with the terminal, but give the light theme
        -- its own background so the terminal's dark background does not show through.
        transparent = style ~= 'light',
        term_colors = true, -- Change terminal color as per the selected theme style
        ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

        -- toggle theme style ---
        toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
        toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

        -- Change code style ---
        -- Options are italic, bold, underline, none
        -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
        code_style = {
            comments = 'italic',
            keywords = 'none',
            functions = 'none',
            strings = 'none',
            variables = 'none'
        },

        -- Lualine options --
        lualine = {
            transparent = false, -- lualine center bar transparency
        },

        -- Custom Highlights --
        colors = {}, -- Override default colors
        highlights = {}, -- Override highlight groups

        -- Plugins Config --
        diagnostics = {
            darker = true, -- darker colors for diagnostic
            undercurl = true,   -- use undercurl instead of underline for diagnostics
            background = true,    -- use background color for virtual text
        },
    }
end

local function apply_theme(style)
    vim.o.background = style == 'light' and 'light' or 'dark'
    require('onedark').setup(theme_options(style))
    require('onedark').load()
end

-- Dark remains the default for every new Neovim process. These commands only
-- change the colors in the current process, so the choice is never persisted.
require('onedark').setup(theme_options('darker'))

vim.api.nvim_create_user_command('LightMode', function()
    apply_theme('light')
end, { desc = 'Use One Light for this Neovim session', force = true })

vim.api.nvim_create_user_command('DarkMode', function()
    apply_theme('darker')
end, { desc = 'Use One Dark for this Neovim session', force = true })

vim.api.nvim_create_user_command('ToggleTheme', function()
    apply_theme(vim.o.background == 'light' and 'darker' or 'light')
end, { desc = 'Toggle the light/dark theme for this Neovim session', force = true })
