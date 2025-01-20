_G.current_viewing_commit = nil
vim.api.nvim_create_autocmd("User", {
    pattern = "DiffviewViewOpened",
    callback = function()
        local view = require("diffview.lib").get_current_view()
        if view then
            if view.rev_arg then
                -- Extract the commit hash by removing the ^! suffix
                local commit = string.gsub(view.rev_arg, "%^!", "")
                _G.current_viewing_commit = commit
                print("Stored commit from rev_arg: " .. (_G.current_viewing_commit or "nil"))
            end
        else
            print("View is nil")
        end
    end
})

_G.get_next_commit = function(direction)
    print("Current viewing commit: " .. (_G.current_viewing_commit or "nil"))
    if _G.current_viewing_commit == nil then
        return
    end
    local target_commit
    if direction == 'next' then
        -- Get the commit that comes chronologically before the current one
        target_commit = vim.fn.trim(vim.fn.system('git rev-list --topo-order HEAD...' .. _G.current_viewing_commit .. ' | tail -1'))
    else
        -- Get the commit that comes chronologically after the current one
        target_commit = vim.fn.trim(vim.fn.system('git rev-list --topo-order HEAD | grep -A 1 ' .. _G.current_viewing_commit .. ' | tail -1'))
    end
    if target_commit ~= "" then
        print("Executing DiffviewOpen with: " .. target_commit)
        vim.cmd('DiffviewClose')
        vim.cmd(string.format('DiffviewOpen %s^!', target_commit))
        _G.current_viewing_commit = target_commit
    else
        print("No target commit found")
    end
end
