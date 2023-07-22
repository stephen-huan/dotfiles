vim.api.nvim_create_augroup("vimrc", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = "vimrc",
    pattern = "tex",
    callback = function(args)
        -- start server on first BufWrite, always call VimtexView
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup(
                string.format("latex<buffer=%d>", args.buf),
                { clear = true }
            ),
            buffer = args.buf,
            callback = function()
                if not vim.b.latex_started then
                    vim.cmd "VimtexCompile"
                    vim.b.latex_started = true
                end
                vim.cmd "VimtexView"
            end,
        })
    end,
})
-- enable spellcheck for text files
vim.api.nvim_create_autocmd("Filetype", {
    group = "vimrc",
    pattern = { "gitcommit", "mail", "markdown", "tex", "text" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
    end,
})
-- terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
    group = "vimrc",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
})
