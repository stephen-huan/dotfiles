-- needs to be before the package is loaded
vim.g.polyglot_disabled = { "sensible", "ftdetect" }
require "plugins"
require "options"
require "keybinds"
require "autocmds"

-- https://vim.fandom.com/wiki/Remove_unwanted_spaces
vim.api.nvim_create_user_command("StripWhitespace", function()
    -- https://stackoverflow.com/questions/23649878/
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
end, {})

