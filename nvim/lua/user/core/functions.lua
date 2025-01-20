-- Make the function global
_G.copy_files_to_clipboard = function(selected_files)
    local data = {}
    for _, filepath in ipairs(selected_files) do
        local file_content = vim.fn.readfile(filepath)
        for _, line in ipairs(file_content) do
            table.insert(data, line)
        end
        table.insert(data, "")  -- add a newline after each file
    end
    local clipboard_content = table.concat(data, "\n")
    vim.fn.setreg("+", clipboard_content)

    print("Copied " .. #selected_files .. " file(s) to clipboard")
end

-- Create a Vim function to call the Lua function
vim.cmd([[
function! CopyFilesToClipboard(selected_files)
    call luaeval('_G.copy_files_to_clipboard(_A)', a:selected_files)
endfunction
]])

vim.cmd([[
command! FZFCopy call fzf#run(fzf#wrap({
    \ 'source': 'rg --files',
    \ 'sink*': function('CopyFilesToClipboard'),
    \ 'options': '+m --multi --header "Select multiple files with \<tab\>"'
    \ }))
]])
