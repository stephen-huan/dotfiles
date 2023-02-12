-- needs to be before the package is loaded
vim.g.polyglot_disabled = { "sensible" }
require "plugins"
require "options"

vim.cmd(":source ~/.config/nvim/init_.vim")

