return require("packer").startup(function(use)
    -- package manager
    use "wbthomason/packer.nvim"

    -- colorscheme, fork of habamax/vim-polar
    use {
        "stephen-huan/polar.nvim",
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
                        { "percent" },
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
            vim.keymap.set(
                "n",
                "<leader>s",
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
    -- show git in the gutter
    use {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup {
                current_line_blame_opts = {
                    delay = 100,
                },
                yadm = {
                    enable = true,
                },
                -- buffer local keybindings
                on_attach = function(bufnr)
                    local gitsigns = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    map("n", "[c", gitsigns.prev_hunk)
                    map("n", "]c", gitsigns.next_hunk)
                    map("n", "ghp", gitsigns.preview_hunk)
                    map("n", "ghb", gitsigns.toggle_current_line_blame)
                    map("n", "ghd", gitsigns.toggle_deleted)
                    map("n", "ghu", gitsigns.undo_stage_hunk)
                    map("n", "ghs", gitsigns.stage_hunk)
                    map("n", "ghS", gitsigns.stage_buffer)
                    map("n", "ghr", gitsigns.reset_hunk)
                    map("n", "ghR", gitsigns.reset_buffer)
                end,
            }
        end,
    }
    -- go to the last position when loading a file
    use "farmergreg/vim-lastplace"
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
            vim.keymap.set(
                "n",
                "<leader>r",
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
                vim.fn["fzf#run"](vim.fn["fzf#wrap"] {
                    source = "fish -c '_z'",
                    sink = "cd",
                    options = {
                        "--preview",
                        "_preview_path {}",
                        "--tiebreak=index",
                    },
                })
            end)
        end,
    }
    -- fzf + vim integration
    use {
        "junegunn/fzf.vim",
        config = function()
            -- keybindings
            for _, mode in pairs { "n", "i", "x", "o" } do
                vim.keymap.set(
                    mode,
                    "<c-p>",
                    "<plug>(fzf-maps-" .. mode .. ")"
                )
            end
            -- complete path
            vim.keymap.set("i", "<c-x><c-f>", "<plug>(fzf-complete-path)")
            -- lines from any buffer
            vim.keymap.set("i", "<c-x><c-l>", "<plug>(fzf-complete-line)")
            -- leader shortcuts
            for key, cmd in pairs {
                o = "Files", -- files with fzf
                a = "Ag", -- ag searcher
                L = "BLines", -- lines in current buffer
                W = "Windows", -- windows
                H = "Helptags", -- help
            } do
                vim.keymap.set(
                    "n",
                    "<leader>" .. key,
                    "<cmd>" .. cmd .. "<cr>"
                )
            end
        end,
    }

    -- autocomplete
    use {
        "hrsh7th/nvim-cmp",
        config = function()
            require "config.autocomplete"
        end,
    }
    -- autocomplete source plugins
    use {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
    }
    -- snippets engine
    use {
        "L3MON4D3/LuaSnip",
        run = "make install_jsregexp",
        config = function()
            local luasnip = require "luasnip"
            -- https://github.com/L3MON4D3/LuaSnip/issues/525
            luasnip.setup {
                region_check_events = { "CursorHold", "InsertLeave" },
                delete_check_events = { "TextChanged", "InsertLeave" },
            }
            -- load snippets
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_snipmate").lazy_load()
            -- keybindings
            vim.keymap.set("i", "<s-cr>", function()
                if luasnip.expand_or_jumpable() then
                    return "<plug>luasnip-expand-or-jump"
                else
                    return "<s-cr>"
                end
            end, { expr = true, silent = true })
        end,
    }
    -- community snippets
    use "honza/vim-snippets"

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
    -- detect indent and adjust indent options
    use "tpope/vim-sleuth"
    -- misc. text operations
    use "godlygeek/tabular"
    -- matching
    use "andymass/vim-matchup"
    -- insert pairs automatically
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {
                check_ts = true,
                enable_afterquote = false,
            }
            require "config.autopairs"
        end,
    }
    -- move around easily
    use {
        "ggandor/leap.nvim",
        config = function()
            -- keybindings
            require("leap").add_default_mappings()
        end,
    }

    -- plugins for specific languages

    -- lsp installation
    use {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup {
                ui = {
                    icons = {
                        package_installed = "o",
                        package_pending = "~",
                        package_uninstalled = "x",
                    },
                },
            }
        end,
    }
    -- lsp configuration
    use {
        "neovim/nvim-lspconfig",
        config = function()
            require "config.lsp"
        end,
    }
    -- linting
    use {
        "mfussenegger/nvim-lint",
        config = function()
            require "config.lint"
        end,
    }
    -- formatting
    use {
        "mhartington/formatter.nvim",
        config = function()
            require "config.format"
        end,
    }
    -- tree-sitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "all",
                highlight = {
                    enable = true,
                    disable = { "latex", "gitcommit", "julia" },
                },
                indent = {
                    enable = true,
                    disable = { "python" },
                },
                matchup = {
                    enable = true,
                },
            }
        end,
    }
    -- tree-sitter utilities
    use "nvim-treesitter/playground"
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
        end,
    }
    -- cython
    use "lambdalisue/vim-cython-syntax"
    -- julia
    use "JuliaEditorSupport/julia-vim"
    -- lean
    use {
        "Julian/lean.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            local on_attach = require("config.lsp").on_attach
            require("lean").setup {
                abbreviations = { builtin = true },
                lsp = { on_attach = on_attach },
                -- lsp3 = { on_attach = on_attach },
                mappings = true,
            }
        end,
    }
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
