-- utilities for creating configurations
local util = require("formatter.util")
local packages = require("config.lsp").packages

-- register formatters for each filetype
local formatters_by_ft = {}
for language, types in pairs(packages) do
    if types.formatter then
        formatters_by_ft[language] = {}
        for _, formatter in pairs(types.formatter) do
            table.insert(
                formatters_by_ft[language],
                require("formatter.filetypes." .. language)[formatter.name]
            )
        end
    end
end

-- keybindings
local opts = { noremap = true, silent = true }
-- try to avoid conflicts with lsp
-- vim.keymap.set({ "n", "v" }, "<leader>f", ":Format<cr>", opts)
vim.keymap.set({ "n", "v" }, "<leader>F", ":Format<cr>", opts)

-- adjust formatter configuration

-- https://prettier.io/docs/en/configuration.html
-- https://prettier.io/docs/en/options.html
formatters_by_ft.json = {
    function()
        return {
            exe = "prettier",
            args = {
                "--stdin-filepath",
                util.escape_path(util.get_current_buffer_file_path()),
                "--config",
                vim.fn.stdpath("config") .. "/lsp/prettier/prettierrc.json",
            },
            stdin = true,
            try_node_modules = true,
        }
    end,
}

-- https://pycqa.github.io/isort/docs/major_releases/introducing_isort_5.html
formatters_by_ft.cython = {
    function()
        return {
            exe = "isort",
            args = { "-q", "-" },
            stdin = true,
        }
    end,
}

require("formatter").setup({
    filetype = formatters_by_ft,
})

