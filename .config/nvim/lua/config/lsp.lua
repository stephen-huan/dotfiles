-- installed mason packages
local packages = {
    lua = {
        lsp = {
            -- https://github.com/LuaLS/lua-language-server
            "lua-language-server",
        },
        linter = {
            -- https://github.com/Kampfkarren/selene
            "selene",
        },
    },
    test = {
        lsp = {
            "hi"
        }
    }
}

-- command to install specified packages
vim.api.nvim_create_user_command("MasonInstallAll", function()
    for _, language in pairs(packages) do
        for type, list in pairs(language) do
            for _, package in pairs(list) do
                vim.cmd("MasonInstall " .. package)
            end
        end
    end
end, {})

return {
    packages = packages,
}
