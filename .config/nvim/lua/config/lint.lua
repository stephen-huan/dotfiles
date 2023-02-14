local lint = require("lint")

-- register linters for each filetype
lint.linters_by_ft = {
    lua = { "selene" },
}
-- autocmd
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = "vimrc",
    pattern = {
        "*.lua",
    },
    callback = function()
        lint.try_lint()
    end,
})

-- adjust linter configuration

-- add neovim environment
lint.linters.selene.args = {
    "--display-style", "json",
    "--config", vim.fn.stdpath("config") .. "/lsp/selene/selene.toml",
}

