local options = require "options"

options.set_options({
    -- fix indentation
    shiftwidth = 2,
    tabstop = 2,
    -- really works! https://stackoverflow.com/questions/8300982/
    -- cursorline = false,
}, "local")
