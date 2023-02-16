vim.api.nvim_create_augroup("vimrc", { clear = true })

-- start server on first BufWrite, always call VimtexView
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "vimrc",
    pattern = "*.tex",
    callback = function()
        if vim.g.latex_started == 0 then
            vim.cmd("VimtexCompile")
            vim.g.latex_started = 1
        end
        vim.cmd("VimtexView")
    end,
})
-- enable spellcheck for text files
vim.api.nvim_create_autocmd("Filetype", {
    group = "vimrc",
    pattern = {
        "gitcommit",
        "mail",
        "markdown",
        "tex",
        "text",
    },
    command = "setlocal spell spelllang=en_us",
})
-- terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
    group = "vimrc",
    callback = function()
        vim.cmd("setlocal nonumber norelativenumber signcolumn=no")
    end,
})

