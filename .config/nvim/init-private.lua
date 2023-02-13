-- pass will automatically do some of this, even with no configuration
-- https://git.zx2c4.com/password-store/tree/contrib/vim/redact_pass.vim

vim.opt.shada = ""
vim.opt.history = 0
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false
vim.opt.secure = true
vim.opt.modeline = false
vim.opt.shelltemp = false

-- save file for all modes
vim.keymap.set({ "", "!" }, "<c-s>", "<cmd>w<cr>")
-- exit file for all modes
vim.keymap.set({ "", "!" }, "<c-q>", "<cmd>q!<cr>")

