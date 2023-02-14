-- installed mason packages
local packages = {
    -- lua

    -- lsp: https://github.com/LuaLS/lua-language-server
    "lua-language-server",
    -- linter: https://github.com/Kampfkarren/selene
    "selene",
}

-- command to install specified packages
vim.api.nvim_create_user_command("MasonInstallAll", function()
    for _, package in ipairs(packages) do
        vim.cmd("MasonInstall " .. package)
    end
end, {})

