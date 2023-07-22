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
vim.keymap.set("", "<c-h>h", "<cmd>Inspect<cr>")

-- leader shortcuts

vim.g.mapleader = " "
vim.g.maplocalleader = "  "

-- toggle search highlight
vim.keymap.set("n", "<leader>c", "<cmd>set hlsearch! hlsearch?<cr>")
-- toggle spellcheck
vim.keymap.set("n", "<leader>C", "<cmd>set spell! spell?<cr>")
-- source vimrc
vim.keymap.set("n", "<leader>v", function()
    vim.cmd [[
        source ~/.config/nvim/init.lua
        source ~/.config/nvim/lua/plugins.lua
        PackerCompile
    ]]
end)
-- reset syntax
-- vim.keymap.set("n", "<leader>e", "<cmd>syntax off <bar> syntax on<cr>")
