-- the equivalent of :map and :map!
local modes = { "", "!" }

-- move visually
vim.keymap.set("", "<down>", "gj")
vim.keymap.set("", "<up>", "gk")

-- ctrl shortcuts

-- save file for all modes
vim.keymap.set(modes, "<c-s>", "<cmd>w<cr>")
-- exit file for all modes
vim.keymap.set(modes, "<c-q>", "<cmd>q!<cr>")
-- exit all tabs for all modes
vim.keymap.set(modes, "<c-j>", "<cmd>qa!<cr>")
-- new tab
vim.keymap.set("n", "<c-n>", "<cmd>tabnew<cr>")
-- show highlight under cursor
vim.keymap.set("", "<c-h>h", function()
    local colorID = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)
    local transID = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 0)
    local hi = vim.fn.synIDattr(colorID, "name")
    local trans = vim.fn.synIDattr(transID, "name")
    local lo = vim.fn.synIDattr(vim.fn.synIDtrans(colorID), "name")
    print(string.format("hi<%s> trans<%s> lo<%s>", hi, trans, lo))
end)

-- leader shortcuts

vim.g.mapleader = " "

-- toggle search highlight
vim.keymap.set("n", "<leader>c", "<cmd>set hlsearch! hlsearch?<cr>")
-- toggle spellcheck
vim.keymap.set("n", "<leader>C", "<cmd>set spell! spell?<cr>")
-- source vimrc
vim.keymap.set("n", "<leader>v", function()
    vim.cmd([[
        source ~/.config/nvim/init.lua
        source ~/.config/nvim/lua/plugins.lua
        PackerCompile
    ]])
end)
-- reset syntax
-- vim.keymap.set("n", "<leader>e", "<cmd>syntax off <bar> syntax on<cr>")

