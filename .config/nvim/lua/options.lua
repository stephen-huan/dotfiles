-- helper function to set options
function set_options(options, scope)
    scope = scope or "glocal"
    local lookup = {
       ["glocal"] = vim.opt,
       ["global"] = vim.opt_global,
       [ "local"] = vim.opt_local,
    }
    local dictionary = lookup[scope]
    for key, value in pairs(options) do
        dictionary[key] = value
    end
end

-- default options: list of options ':options'
local options = {
    -- miscellaneous

    -- shell
    shell = "/bin/fish",
    -- use system clipboard
    clipboard = { "unnamed", "unnamedplus" },
    -- disable mouse support
    mouse = "",

    -- editing

    -- force unix line endings
    fileformats = { "unix" },
    -- make backspace always work
    backspace = { "indent", "eol", "start" },
    -- number of visual spaces per tab
    tabstop = 4,
    -- change tab into spaces
    expandtab = true,
    -- since tab = spaces, tabs don't exist
    softtabstop = 0,
    -- number of spaces for shifting
    shiftwidth = 4,
    -- round shifts to the nearest multiple
    shiftround = true,
    -- autoindent based on current line
    autoindent = true,
    -- get autoindent from other lines
    copyindent = true,
    -- number formats for ctrl-a and ctrl-x
    nrformats = { "alpha", "hex", "bin" },
    -- tilde ~ (switch case) as operator
    tildeop = true,
    -- (f)ast rewrite of p(ar)
    formatprg = "far",

    -- appearance

    -- 24 bit colors
    termguicolors = true,
    -- light background
    background = "light",
    -- draw status bar for each window
    laststatus = 2,
    -- show an incomplete command
    showcmd = true,
    -- don't show mode, shown in bar already
    showmode = false,
    -- visual autocomplete for command menu
    wildmenu = true,
    -- line numbers
    number = true,
    -- numbers relative to cursor line
    relativenumber = true,
    -- highlight current line
    cursorline = true,
    -- screenline vs file line
    cursorlineopt = { "screenline", "number" },
    -- disable matching [{()}]
    showmatch = false,
    -- show whitespace with characters
    list = true,
    -- wrap if longer than window size
    wrap = true,
    -- disable break on specific characters
    linebreak = false,
    -- show when the lines are wrapped
    showbreak = "> ",
    -- match indentation on wrapping
    breakindent = true,
    -- display bar at 80 characters
    colorcolumn = "80",
    -- always draw signcolumn
    signcolumn = "yes",
    -- truncate last line, display unicode as hex
    display = { "truncate", "uhex" },

    -- search

    -- ignore upper/lower case when searching
    ignorecase = true,
    -- case sensitive if upper case
    smartcase = true,
    -- show partial matches for a search phrase
    incsearch = true,
    -- highlight all matching phrases
    hlsearch = true,
    -- wrap search
    wrapscan = true,

    -- backup/undo/swap

    -- store backups
    backup = true,
    -- store file at ~/.local/state, defaulting to . if not found
    backupdir = { vim.fn.expand("~/.local/state/nvim/backup//"), "." },
    -- store original files (doesn't store to backupdir)
    -- patchmode = ".orig"
    -- store undo information to a file
    undofile = true,
    -- swapfile write and cursor update frequency
    updatetime = 100,

    -- insert completions

    -- open extra information in a popup window
    completeopt = { "menuone", "preview" },
    -- smartcase but for completions
    infercase = true,

    -- windows

    -- split windows below
    splitbelow = true,
    -- split windows right
    splitright = true,

    -- keybindings

    -- wait for mappings, if they are a prefix
    timeout = true,
    -- timeout for key codes
    ttimeout = true,
    -- delay for mappings until timeout
    timeoutlen = 1000,
    -- delay for key codes
    ttimeoutlen = 10,
}

set_options(options)

-- options that can't be set with set_options

vim.g.mapleader = " "

-- providers

vim.g.python_host_prog   = "/usr/bin/python"
vim.g.python3_host_prog  = "/usr/bin/python"

-- spellcheck

-- add thesaurus
-- vim.opt.thesaurus:append("~/.vim/thesaurus/english.txt")
-- add dictionary
-- vim.opt.dictionary:append("/usr/share/dict/words")
-- spelling in autocomplete
vim.opt.complete:append("kspell")

-- sessions

-- remove blank files from sessions
vim.opt.sessionoptions:remove("blank")

