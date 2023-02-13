require "options"

set_options({
    -- limit to 72 character width lines
    colorcolumn = "73",
    -- manually reflow
    textwidth = 0,
    -- par is cleaner for emails
    -- formatprg = "par w 72",
    formatprg = "far 72",
    -- don't use modelines since we view other people's emails
    modeline = false,
}, "local")

-- remap goyo to 72 characters
vim.keymap.set("n", "<leader>y", "<cmd>Goyo 73<cr>")

-- vim-sleuth takes a long time
vim.b.sleuth_automatic = 0

