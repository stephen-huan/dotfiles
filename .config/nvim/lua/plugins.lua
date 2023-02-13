return require("packer").startup(function(use)
    -- package manager
    use "wbthomason/packer.nvim"

    -- colorscheme, fork of habamax/vim-polar
    use {
        "stephen-huan/vim-polar",
        config = function()
            -- set colorscheme
            vim.cmd.colorscheme "polar"
        end,
    }
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
            -- keybindings
            vim.keymap.set("n", "<leader>s",
                "<cmd>execute 'SSave!' . fnamemodify(v:this_session, ':t')<cr>"
            )
        end,
    }

    -- distraction free writing
    use {
        "junegunn/goyo.vim",
        config = function()
            -- weirdly, goyo character width changes by two
            vim.g.goyo_width = 81
            -- keybindings
            vim.keymap.set("n", "<leader>y", "<cmd>Goyo<cr>")
        end,
    }
    -- visualize undo tree
    use {
        "mbbill/undotree",
        config = function()
            -- open on right side
            vim.g.undotree_WindowLayout = 3
            -- keybindings
            vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>")
        end,
    }
    -- go to the last position when loading a file
    use "farmergreg/vim-lastplace"
    -- show git in the gutter
    use {
        "airblade/vim-gitgutter",
        config = function()
            vim.g.gitgutter_map_keys = 0
            -- keybindings
            for pair, cmd in pairs({
                [{ "n", "ghp" }] = "PreviewHunk",
                [{ "n", "ghs" }] = "StageHunk",
                [{ "n", "ghu" }] = "UndoHunk",
                [{ "n", "[c"  }] = "PrevHunk",
                [{ "n", "]c"  }] = "NextHunk",
                [{ "o", "ic"  }] = "TextObjectInnerPending",
                [{ "o", "ac"  }] = "TextObjectOuterPending",
                [{ "x", "ic"  }] = "TextObjectInnerVisual",
                [{ "x", "ac"  }] = "TextObjectOuterVisual",
            }) do
                local mode, key = unpack(pair)
                vim.keymap.set(mode, key, "<plug>(GitGutter" .. cmd ..  ")")
            end
        end,
    }
    -- allow plugins to . repeat
    use "tpope/vim-repeat"

    -- ranger integration
    use {
        "francoiscabrol/ranger.vim",
        requires = { "rbgrouleff/bclose.vim" },
        config = function()
            vim.g.ranger_replace_netrw = 1
            vim.g.ranger_map_keys = 0
            -- keybindings
            vim.keymap.set("n", "<leader>r",
                "<cmd>RangerCurrentDirectoryNewTab<cr>"
            )
        end,
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
            -- directory jumping with z
            vim.keymap.set("n", "<leader>g", function()
                vim.fn["fzf#run"](vim.fn["fzf#wrap"]({
                    source = "fish -c '_z'",
                    sink = "cd",
                    options = {
                        "--preview", "_preview_path {}",
                        "--tiebreak=index",
                    },
                }))
            end)
        end,
    }
    -- fzf + vim integration
    use {
        "junegunn/fzf.vim",
        config = function()
            -- keybindings
            for i, mode in pairs({ "n", "i", "x", "o" }) do
                vim.keymap.set(mode, "<c-p>",
                    "<plug>(fzf-maps-" .. mode .. ")"
                )
            end
            -- complete path
            vim.keymap.set("i", "<c-x><c-f>", "<plug>(fzf-complete-path)")
            -- lines from any buffer
            vim.keymap.set("i", "<c-x><c-l>", "<plug>(fzf-complete-line)")
            -- leader shortcuts
            for key, cmd in pairs({
                o = "Files",    -- files with fzf
                a = "Ag",       -- ag searcher
                L = "BLines",   -- lines in current buffer
                W = "Windows",  -- windows
                H = "Helptags", -- help
            }) do
                vim.keymap.set("n", "<leader>" .. key,
                    "<cmd>" .. cmd .. "<cr>"
                )
            end
        end,
    }

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

    -- comment
    use {
        "tomtom/tcomment_vim",
        config = function()
            vim.g.tcomment_mapleader1 = "<c-.>"
            -- <c-_> is ctrl + /
            vim.keymap.set("", "<c-_>", ":TComment<cr>")
            vim.keymap.set("", "<leader>/", ":TCommentBlock<cr>")
        end,
    }
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
    -- move around easily
    use {
        "easymotion/vim-easymotion",
        config = function()
            -- equivalent to vim's smartcase
            vim.g.EasyMotion_smartcase = 1
            -- don't change cursor position
            vim.g.EasyMotion_startofline = 0
            -- keybindings
            for key, cmd in pairs({
                s = "jumptoanywhere",
                ["<leader>w"] = "w",
                ["<leader>f"] = "f",
                ["<s-right>"] = "lineforward",
                ["<s-left>"] = "linebackward",
                ["<s-down>"] = "j",
                ["<s-up>"] = "k",
                [";"] = "next",
                [","] = "prev",
                ["<leader>n"] = "n",
                ["<leader>N"] = "N",
            }) do
                vim.keymap.set("", key, "<plug>(easymotion-" .. cmd .. ")")
            end
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
            -- keybindings
            vim.keymap.set("", "]h", "<plug>Markdown_MoveToCurHeader")
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
            -- keybindings
            vim.keymap.set("n", "<leader>m", "<plug>MarkdownPreview")
        end,
    }
end)
