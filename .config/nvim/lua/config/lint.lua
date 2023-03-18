local lint = require("lint")
local packages = require("config.lsp").packages

-- register linters for each filetype
lint.linters_by_ft = {}
local languages = {}
for language, types in pairs(packages) do
    if types.linter then
        lint.linters_by_ft[language] = {}
        for _, linter in pairs(types.linter) do
            table.insert(lint.linters_by_ft[language], linter.name)
        end
        table.insert(languages, language)
    end
end

-- autocmd for activating the linter
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = "vimrc",
    pattern = languages,
    callback = function(args)
        local events = { "BufEnter", "BufWritePost", "InsertLeave" }
        vim.api.nvim_create_autocmd(events, {
            group = vim.api.nvim_create_augroup(
                string.format("lint<buffer=%d>", args.buf), { clear = true }
            ),
            buffer = args.buf,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
})

-- keybindings: https://github.com/neovim/nvim-lspconfig
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>l", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>d", function()
    if vim.b.linter_hidden then
        vim.diagnostic.show()
        vim.b.linter_hidden = false
    else
        vim.diagnostic.hide()
        vim.b.linter_hidden = true
    end
end)

-- adjust linter configuration

-- add neovim environment
lint.linters.selene.args = {
    "--display-style", "json",
    "--config", vim.fn.stdpath("config") .. "/lsp/selene/selene.toml",
}

