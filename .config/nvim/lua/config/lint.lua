local lint = require("lint")
local lsp = require("config.lsp")

-- register linters for each filetype
lint.linters_by_ft = {}
local languages = {}
for language, types in pairs(lsp.packages) do
    if types.linter then
        lint.linters_by_ft[language] = types.linter
        table.insert(languages, language)
    end
end
-- autocmd
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

-- adjust linter configuration

-- add neovim environment
lint.linters.selene.args = {
    "--display-style", "json",
    "--config", vim.fn.stdpath("config") .. "/lsp/selene/selene.toml",
}

