return require("packer").startup(function(use)
    -- package manager
    use "wbthomason/packer.nvim"

    -- colorscheme, fork of habamax/vim-polar
    use "stephen-huan/vim-polar"
    -- statusline
    use {
        "itchyny/lightline.vim",
        config = function()
            vim.g.lightline = {
                -- set lightline colorscheme
                colorscheme = "polar",
                -- remove 'fileformat' and 'fileencoding' from the default bar
                active = {
                    right = {
                        { "lineinfo" },
                        { "percent"  },
                        { "filetype" },
                    },
                },
            }
        end,
    }
    -- startup manager
    use {
        "mhinz/vim-startify",
        config = function()
            -- custom header
            vim.g.startify_custom_header = ""
            -- update sessions
            vim.g.startify_session_persistence = 0
        end,
    }

    -- distraction free writing
    use {
        "junegunn/goyo.vim",
        config = function()
            -- weirdly, goyo character width changes by two
            vim.g.goyo_width = 81
        end,
    }
    -- visualize undo tree
    use {
        "mbbill/undotree",
        config = function()
            -- open on right side
            vim.g.undotree_WindowLayout = 3
        end,
    }
    -- automatically load changed files
    use "djoshea/vim-autoread"
    -- go to the last position when loading a file
    use "farmergreg/vim-lastplace"
    -- show git in the gutter
    use "airblade/vim-gitgutter"
    -- allow plugins to . repeat
    use "tpope/vim-repeat"
    -- measure startup time
    use "dstein64/vim-startuptime"

    -- ranger integration
    use {
        "francoiscabrol/ranger.vim",
        requires = { "rbgrouleff/bclose.vim" },
    }
    -- fzf
    use {
        "junegunn/fzf",
        config = function()
            -- start in new window
            vim.g.fzf_layout = {
                window = {
                    width = 0.9,
                    height = 0.6,
                    border = "rounded",
                },
            }
        end,
    }
    -- fzf + vim integration
    use "junegunn/fzf.vim"

    -- autocomplete
    use {
        "ycm-core/YouCompleteMe",
        config = function()
            -- run in comments
            vim.g.ycm_complete_in_comments = 1
            -- fix YCM overwriting tab expansion for snippets
            vim.g.ycm_key_list_select_completion = { "<down>" }
            vim.g.ycm_key_list_previous_completion = { "<up>" }
        end,
    }
    -- snippets engine
    use {
        "SirVer/ultisnips",
        config = function()
            -- directories
            vim.g.UltiSnipsSnippetDirectories = {
                "UltiSnips",
                "snipps",
            }
            -- shortcuts
            vim.g.UltiSnipsExpandTrigger = "<tab>"
            vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
            vim.g.UltiSnipsJumpBackwardTrigger = "<c-b>"
        end,
    }
    -- community snippets
    use "honza/vim-snippets"

    -- comment
    use "tomtom/tcomment_vim"
    -- detect indent and adjust indent options
    use "tpope/vim-sleuth"
    -- editing character pairs
    use "tpope/vim-surround"
    -- miscellaneous text operations
    use "godlygeek/tabular"
    -- matching
    use "andymass/vim-matchup"
    -- insert pairs automatically
    use {
        "vim-scripts/auto-pairs-gentle",
        config = function()
            -- 'gentle' algorithm
            vim.g.AutoPairsUseInsertedCount = 1
        end,
    }
    -- highlight extra whitespace
    use {
        "ntpeters/vim-better-whitespace",
        config = function()
            -- disable highlighting on these filetypes
            vim.g.better_whitespace_filetypes_blacklist = {
                "startify",
            }
        end,
    }
    -- move around easily
    use {
        "easymotion/vim-easymotion",
        config = function()
            -- equivalent to vim's smartcase
            vim.g.EasyMotion_smartcase = 1
            -- don't change cursor position
            vim.g.EasyMotion_startofline = 0
        end,
    }

    -- plugins for specific languages

    -- language pack
    use {
        "sheerun/vim-polyglot",
        config = function()
            -- highlight python
            vim.g.python_highlight_all = 1

            -- disable autofold
            vim.g.vim_markdown_folding_disabled = 1
            -- ~~strikethrough~~
            vim.g.vim_markdown_strikethrough = 1
            -- LaTeX
            vim.g.vim_markdown_math = 1
        end,
    }
    -- LaTeX
    use {
        "lervag/vimtex",
        config = function()
            -- don't use plain TeX
            vim.g.tex_flavor = "latex"
            -- set PDF viewer
            vim.g.vimtex_view_method = "sioyek"
            -- vim.g.vimtex_view_sioyek_exe = "sioyek"
            -- automatically close quickfix menu
            vim.g.vimtex_quickfix_autoclose_after_keystrokes = 3
            vim.g.vimtex_compiler_latexmk = {
                executable = "latexmk",
                options = {
                    "-verbose",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "-shell-escape",
                },
            }

            -- start server on first BufWrite, always call VimtexView
            vim.g.latex_started = 0
        end,
    }
    -- email
    use "neomutt/neomutt.vim"
    -- fish shell
    use "dag/vim-fish"
    -- git
    use "tpope/vim-git"
    -- cython
    -- use "lambdalisue/vim-cython-syntax"
    use "stephen-huan/vim-cython-syntax"
    -- julia
    use "JuliaEditorSupport/julia-vim"
    -- markdown preview
    use {
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install",
        config = function()
            -- browser
            vim.g.mkdp_browser = "firefox"
        end,
    }
    -- jinja, setting up matchup
    use "Glench/Vim-Jinja2-Syntax"
end)
