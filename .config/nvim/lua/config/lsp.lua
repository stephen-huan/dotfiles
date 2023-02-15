local lspconfig = require("lspconfig")
-- add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- installed mason packages
local packages = {
    lua = {
        lsp = {
            -- https://github.com/LuaLS/lua-language-server
            {
                package = "lua-language-server",
                name = "lua_ls",
            },
        },
        linter = {
            -- https://github.com/Kampfkarren/selene
            {
                package = "selene",
                name = "selene",
            },
        },
    },
}

-- command to install specified packages
vim.api.nvim_create_user_command("MasonInstallAll", function()
    for _, language in pairs(packages) do
        for _, list in pairs(language) do
            for _, package in pairs(list) do
                vim.cmd("MasonInstall " .. package.package)
            end
        end
    end
end, {})

-- use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    -- enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- extra keybindings: https://github.com/neovim/nvim-lspconfig
    local function map(mode, l, r, opts)
        opts = opts or { noremap = true, silent = true }
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end

    map("n", "gD", vim.lsp.buf.declaration)
    map("n", "gd", vim.lsp.buf.definition)
    map("n", "K", vim.lsp.buf.hover)
    map("n", "gi", vim.lsp.buf.implementation)
    map("n", "<C-k>", vim.lsp.buf.signature_help)
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
    map("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end)
    map("n", "<leader>D", vim.lsp.buf.type_definition)
    map("n", "<leader>rn", vim.lsp.buf.rename)
    map("n", "<leader>ca", vim.lsp.buf.code_action)
    map("n", "gr", vim.lsp.buf.references)
    map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end)
end

-- enable lsp with the additional completion capabilities offered by nvim-cmp
for _, language in pairs(packages) do
    if language.lsp then
        for _, lsp in pairs(language.lsp) do
            lspconfig[lsp.name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end
    end
end

-- adjust lsp configuration: https://github.com/neovim/nvim-lspconfig/
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                -- get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- make the server aware of neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                -- https://github.com/neovim/nvim-lspconfig/issues/1700
                checkThirdParty = false,
            },
            telemetry = {
                -- do not send telemetry data
                enable = false,
            },
        },
    },
})

return {
    packages = packages,
}
