local utils = require("utils")

local plugin_dir = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_dir .. "/lazy.nvim"

local zsh_path = vim.fn.system('which zsh'):gsub('\n', '')

vim.o.shell = zsh_path

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- check if firenvim is active
local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

local plugin_specs = {
  -- auto-completion engine
  {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    -- event = 'InsertEnter',
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-omni",
      "quangnguyen30192/cmp-nvim-ultisnips",
    },
    config = function()
      require("config.nvim-cmp")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("config.lsp")
    end,
  },
  -- lspaga
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("lspsaga").setup({
        -- Symbol in windar (top right corner)
        symbol_in_winbar = {
          enable = true,
          separator = " > ",
          ignore_patterns = {},
          hide_keyword = true,
          show_file = true,
          folder_level = 2,
          respect_root = false,
          color_mode = true,
        },
        -- UI settings with compatible icons
        ui = {
          border = "rounded",
          winblend = 10,
          title = true,
          devicon = true,
          expand = "+",
          collapse = "-",
          code_action = ">>",
          incoming = "<-",
          outgoing = "->",
          hover = '?',
          kind = {},
        },
        -- Rename settings
        rename = {
          in_select = true,
          auto_save = true,
          project_max_width = 0.5,
          project_max_height = 0.5,
          keys = {
            quit = "<ESC>",
            exec = "<CR>",
            select = "x",
          },
        },
        --Find settings for symbol navigation
        finder = {
          max_height = 0.6,
          min_width = 30,
          force_max_height = false,
          keys = {
            jump_to = 'p',
            expand_or_jump = 'o',
            vsplit = 's',
            split = 'i',
            tabe = 't',
            quit = { 'q', '<ESC>' },
            close_in_preview = '<ESC>',
          },
        },
        -- Outline settings
        outline = {
          win_position = "right",
          win_width = 30,
          auto_preview = true,
          detail = true,
          auto_close = true,
          close_after_jump = true,
          layout = "normal",
          max_height = 0.6,
          left_width = 0.3,
          keys = {
            jump = 'o',
            expand_collapse = 'u',
            quit = 'q',
          },
        },
        -- Code actions
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = true,
          keys = {
            quit = "q",
            exec = "<CR>",
          },
        },
        -- Optional: custom keymaps
        lightbulb = {
          enable = true,
          enable_in_insert = true,
          sign = true,
          sign_priority = 40,
          virtual_text = true,
        }
      })

      -- Set up keymaps for easier navigation
      local keymap = vim.keymap.set
      -- Symbol finder
      keymap("n", "<space>lo", "<cmd>Lspsaga finder<CR>", { desc = "LSP Symbol Finder" })

      keymap("n", "<space>ls", "<cmd>Lspsaga outline<CR>", { desc = "LSP Outline" })

      keymap("n", "<space>ld", "<cmd>Lspsaga peek_definition<CR>", { desc = "LSP Peek Definition" })

      keymap("n", "<space>lD", "<cmd>Lspsaga goto_definition<CR>", { desc = "LSP Goto Definition" })

      keymap("n", "<space>lw", "<cmd>Lspsaga winbar_toggle<CR>", { desc = "LSP Toggle Winbar Symbols" })
    end,
  },
  -- lsp signature
  {
    "ray-x/lsp_signature.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local signature_config = {
        -- General settings
        debug = false,   -- Set to true for debug logging
        log_path = vim.fn.stdpath("cache") .. "~/lsp_signature.log",
        verbose = false, -- Show verbose log messages

        -- Floating window settings
        bind = true,                           -- Bind to keymaps if provided
        doc_lines = 10,                        -- Maximum number of lines in the signature help window
        max_height = 12,                       -- Max height of signature floating window
        max_width = 80,                        -- Max width of signature floating window
        wrap = true,                           -- Wrap long lines
        floating_window = true,                -- Show floating window for signature
        floating_window_above_cur_line = true, -- Try to place the floating above the current line when possible
        floating_window_off_x = 1,             -- X offset of floating window
        floating_window_off_y = 0,             -- Y offset of floating window (negative value puts it above the cursor)

        -- Visual settings
        fix_pos = false, -- Fix floating window position
        hint_enable = true, -- Virtual text hint
        hint_prefix = "🔍 ", -- Change to a simpler character if needed: "🐼 " or "➡️ " or "» "
        hint_scheme = "String", -- Color scheme for virtual text
        hint_inline = function() return false end, -- When to show inline hints
        hi_parameter = "LspSignatureActiveParameter", -- Color for active parameter
        handler_opts = {
          border = "rounded" -- "shadow", "none", or "rounded"
        },

        -- Always show signature help when typing '(' or ','
        always_trigger = false,          -- Show signature on new line and space
        auto_close_after = nil,          -- Close signature floating window after n seconds
        check_completion_visible = true, -- Don't show if completion menu is visible

        -- Keymaps
        toggle_key = "<C-k>",                     -- Toggle signature on and off with Ctrl-k
        toggle_key_flip_floatwin_setting = false, -- Flip floatwin setting when toggle_key is triggered
        select_signature_key = "<M-n>",           -- Cycle to next signature with Alt-n
        move_cursor_key = nil,                    -- Move cursor to signature with these keys
      }

      -- Initialize the plugin
      require("lsp_signature").setup(signature_config)


      -- Setup signature on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspSignatureSetup", { clear = true }),
        callback = function(args)
          -- Only enable for supported language servers
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            require("lsp_signature").on_attach(signature_config, args.buf)
          end
        end,
      })
    end,
  },
  --lspkind
  {
    "onsails/lspkind.nvim",
  },
  --color-menu
  {
    "xzbdmw/colorful-menu.nvim",
    config = function()
      -- You don't need to set these options.
      require("colorful-menu").setup({
        ls = {
          lua_ls = {
            -- Maybe you want to dim arguments a bit.
            arguments_hl = "@comment",
          },
          gopls = {
            -- By default, we render variable/function's type in the right most side,
            -- to make them not to crowd together with the original label.

            -- when true:
            -- foo             *Foo
            -- ast         "go/ast"

            -- when false:
            -- foo *Foo
            -- ast "go/ast"
            align_type_to_right = true,
            -- When true, label for field and variable will format like "foo: Foo"
            -- instead of go's original syntax "foo Foo". If align_type_to_right is
            -- true, this option has no effect.
            add_colon_before_type = false,
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          -- for lsp_config or typescript-tools
          ts_ls = {
            -- false means do not include any extra info,
            -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
            extra_info_hl = "@comment",
          },
          vtsls = {
            -- false means do not include any extra info,
            -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
            extra_info_hl = "@comment",
          },
          ["rust-analyzer"] = {
            -- Such as (as Iterator), (use std::io).
            extra_info_hl = "@comment",
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          clangd = {
            -- Such as "From <stdio.h>".
            extra_info_hl = "@comment",
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- the hl group of leading dot of "•std::filesystem::permissions(..)"
            import_dot_hl = "@comment",
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
          },
          zls = {
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
          },
          roslyn = {
            extra_info_hl = "@comment",
          },
          dartls = {
            extra_info_hl = "@comment",
          },
          -- The same applies to pyright/pylance
          basedpyright = {
            -- It is usually import path such as "os"
            extra_info_hl = "@comment",
          },
          pylsp = {
            extra_info_hl = "@comment",
            -- Dim the function argument area, which is the main
            -- difference with pyright.
            arguments_hl = "@comment",
          },
          -- If true, try to highlight "not supported" languages.
          fallback = true,
          -- this will be applied to label description for unsupport languages
          fallback_extra_info_hl = "@comment",
        },
        -- If the built-in logic fails to find a suitable highlight group for a label,
        -- this highlight is applied to the label.
        fallback_highlight = "@variable",
        -- If provided, the plugin truncates the final displayed text to
        -- this width (measured in display cells). Any highlights that extend
        -- beyond the truncation point are ignored. When set to a float
        -- between 0 and 1, it'll be treated as percentage of the width of
        -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
        -- Default 60.
        max_width = 60,
      })
    end,
  },
  --toggleterm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = zsh_path,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
  },
  -- Mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd"
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    branch = "main",
  },
  {
    "stevearc/conform.nvim",
  },
  -- Nvim Navic
  {
    "SmiteshP/nvim-navic",
    branch = "master",
  },
  -- For Hover Usage Highlighting
  {
    "RRethy/vim-illuminate",
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
  }, -- to close the gaps between null-ls and mason
  -- TreeSitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },
  -- Node js
  {
    "neoclide/coc.nvim",
    branch = "release"
  },
  -- Python-related text object
  { "jeetsukumaran/vim-pythonsense", ft = { "python" } },

  { "machakann/vim-swap",            event = "VeryLazy" },

  -- IDE for Lisp
  -- 'kovisoft/slimv'
  {
    "vlime/vlime",
    enabled = function()
      if utils.executable("sbcl") then
        return true
      end
      return false
    end,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/vim")
    end,
    ft = { "lisp" },
  },

  -- Super fast buffer jump
  {
    "smoka7/hop.nvim",
    event = "VeryLazy",
    config = function()
      require("config.nvim_hop")
    end,
  },

  -- Show match number and index for searching
  {
    "kevinhwang91/nvim-hlslens",
    branch = "main",
    keys = { "*", "#", "n", "N" },
    config = function()
      require("config.hlslens")
    end,
  },
  -- NeoTree
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   branch = "main",
  --   config = function()
  --     require("config.neotree")
  --   end,
  -- },
  {
    "Yggdroot/LeaderF",
    cmd = "Leaderf",
    build = function()
      local leaderf_path = plugin_dir .. "/LeaderF"
      vim.opt.runtimepath:append(leaderf_path)
      vim.cmd("runtime! plugin/leaderf.vim")

      if not vim.g.is_win then
        vim.cmd("LeaderfInstallCExtension")
      end
    end,
  },
  "nvim-lua/plenary.nvim",
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>qp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup {}
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- main = "render-markdown",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    commit = "a03ed82dfdeb1a4980093609ffe94c171ace8059",
    config = function()
      require('render-markdown').setup({
        completions = { coq = { enabled = true } },
      })
    end,
  },
  -- A list of colorscheme plugin you may want to try. Find what suits you.
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      local rainbow_delimiters = require 'rainbow-delimiters'

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end
  },
  { 'norcalli/nvim-colorizer.lua' },
  { "navarasu/onedark.nvim",       lazy = true },
  { "sainnhe/edge",                lazy = true },
  { "sainnhe/sonokai",             lazy = true },
  { "sainnhe/gruvbox-material",    lazy = true },
  { "sainnhe/everforest",          lazy = true },
  { "EdenEast/nightfox.nvim",      lazy = true },
  { "catppuccin/nvim",             name = "catppuccin", lazy = true },
  { "olimorris/onedarkpro.nvim",   lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },
  {
    "rockyzhang24/arctic.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    name = "arctic",
    branch = "v2",
  },
  { "rebelot/kanagawa.nvim",       lazy = true },
  { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    cond = firenvim_not_active,
    config = function()
      require("config.lualine")
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = { "BufEnter" },
    cond = firenvim_not_active,
    config = function()
      require("config.bufferline")
    end,
  },

  -- fancy start screen
  {
    "nvimdev/dashboard-nvim",
    cond = firenvim_not_active,
    config = function()
      require("config.dashboard-nvim")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    config = function()
      require("config.indent-blankline")
    end,
  },
  { 'lewis6991/impatient.nvim' },
  {
    "luukvbaal/statuscol.nvim",
    opts = {},
    config = function()
      require("config.nvim-statuscol")
    end,
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "justinmk/vim-sneak",
  },
  {
    "easymotion/vim-easymotion",
    config = function()
      vim.g.EasyMotion_do_mapping = 0 -- Disable default mappings

      -- Define key mappings
      vim.api.nvim_set_keymap('n', '<Leader><Leader>w', '<Plug>(easymotion-overwin-w)', {})
      vim.api.nvim_set_keymap('n', '<Leader><Leader>f', '<Plug>(easymotion-bd-f)', {})
      vim.api.nvim_set_keymap('n', '<Leader><Leader>l', '<Plug>(easymotion-lineforward)', {})
      vim.api.nvim_set_keymap('n', '<Leader><Leader>h', '<Plug>(easymotion-linebackward)', {})
    end
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    opts = {},
    init = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      require("config.nvim_ufo")
    end,
  },
  -- Highlight URLs inside vim
  { "itchyny/vim-highlighturl", event = "VeryLazy" },

  -- -- notification plugin
  -- {
  --   "rcarriga/nvim-notify",
  --   event = "VeryLazy",
  --   config = function()
  --     require("config.nvim-notify")
  --   end,
  -- },

  -- For Windows and Mac, we can open an URL in the browser. For Linux, it may
  -- not be possible since we maybe in a server which disables GUI.
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    enabled = function()
      if vim.g.is_win or vim.g.is_mac then
        return true
      else
        return false
      end
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,      -- default settings
    submodules = false, -- not needed, submodules are required only for tests
  },

  -- Only install these plugins if ctags are installed on the system
  -- show file tags in vim window
  -- {
  --   "liuchengxu/vista.vim",
  --   enabled = function()
  --     if utils.executable("ctags") then
  --       return true
  --     else
  --       return false
  --     end
  --   end,
  --   cmd = "Vista",
  -- },

  -- Snippet engine and snippet template
  {
    "SirVer/ultisnips",
    dependencies = {
      "honza/vim-snippets",
    },
    event = "InsertEnter"
  },

  -- Automatic insertion and deletion of a pair of characters
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Comment plugin
  { "tpope/vim-commentary",   event = "VeryLazy" },

  -- Multiple cursor plugin like Sublime Text?
  -- 'mg979/vim-visual-multi'

  -- Autosave files on certain events
  { "907th/vim-auto-save",    event = "InsertEnter" },

  -- Show undo history visually
  { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } },

  -- better UI for some nvim actions
  { "stevearc/dressing.nvim" },

  -- Manage your yank history
  {
    "gbprod/yanky.nvim",
    config = function()
      require("config.yanky")
    end,
    event = "VeryLazy",
  },

  -- Handy unix command inside Vim (Rename, Move etc.)
  { "tpope/vim-eunuch",          cmd = { "Rename", "Delete" } },

  -- Repeat vim motions
  { "tpope/vim-repeat",          event = "VeryLazy" },

  { "nvim-zh/better-escape.vim", event = { "InsertEnter" } },

  {
    "lyokha/vim-xkbswitch",
    enabled = function()
      if vim.g.is_mac and utils.executable("xkbswitch") then
        return true
      end
      return false
    end,
    event = { "InsertEnter" },
  },

  {
    "Neur1n/neuims",
    enabled = function()
      if vim.g.is_win then
        return true
      end
      return false
    end,
    event = { "InsertEnter" },
  },

  -- Auto format tools
  { "sbdchd/neoformat",          cmd = { "Neoformat" } },

  -- Git command inside vim
  {
    "tpope/vim-fugitive",
    event = "User InGitRepo",
    config = function()
      require("config.fugitive")
    end,
  },

  -- Better git log display
  { "rbong/vim-flog",            cmd = { "Flog" } },
  { "akinsho/git-conflict.nvim", version = "*",        config = true },
  {
    "ruifm/gitlinker.nvim",
    event = "User InGitRepo",
    config = function()
      require("config.git-linker")
    end,
  },

  -- Show git change (change, delete, add) signs in vim sign column
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns")
    end,
  },

  {
    "sindrets/diffview.nvim",
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("config.bqf")
    end,
  },

  -- Another markdown plugin
  { "preservim/vim-markdown",           ft = { "markdown" } },

  -- Faster footnote generation
  { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } },

  -- Vim tabular plugin for manipulate tabular, required by markdown plugins
  { "godlygeek/tabular",                cmd = { "Tabularize" } },

  -- Markdown previewing (only for Mac and Windows)
  {
    "iamcco/markdown-preview.nvim",
    enabled = function()
      if vim.g.is_win or vim.g.is_mac then
        return true
      end
      return false
    end,
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  {
    "rhysd/vim-grammarous",
    enabled = function()
      if vim.g.is_mac then
        return true
      end
      return false
    end,
    ft = { "markdown" },
  },

  { "chrisbra/unicode.vim",            event = "VeryLazy" },

  -- Additional powerful text object for vim, this plugin should be studied
  -- carefully to use its full power
  { "wellle/targets.vim",              event = "VeryLazy" },

  -- Plugin to manipulate character pairs quickly
  { "machakann/vim-sandwich",          event = "VeryLazy" },

  -- Add indent object for vim (useful for languages like Python)
  { "michaeljsmith/vim-indent-object", event = "VeryLazy" },

  -- Only use these plugin on Windows and Mac and when LaTeX is installed
  {
    "lervag/vimtex",
    enabled = function()
      if utils.executable("latex") then
        return true
      end
      return false
    end,
    ft = { "tex" },
  },

  -- Since tmux is only available on Linux and Mac, we only enable these plugins
  -- for Linux and Mac
  -- .tmux.conf syntax highlighting and setting check
  {
    "tmux-plugins/vim-tmux",
    enabled = function()
      if utils.executable("tmux") then
        return true
      end
      return false
    end,
    ft = { "tmux" },
  },

  -- Tmux navigation
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- Modern matchit implementation
  { "andymass/vim-matchup",     event = "BufRead" },
  { "tpope/vim-scriptease",     cmd = { "Scriptnames", "Messages", "Verbose" } },

  -- Asynchronous command execution
  { "skywind3000/asyncrun.vim", lazy = true,                                   cmd = { "AsyncRun" } },
  { "cespare/vim-toml",         ft = { "toml" },                               branch = "main" },

  -- Edit text area in browser using nvim
  {
    "glacambre/firenvim",
    enabled = function()
      local result = vim.g.is_win or vim.g.is_mac
      return result
    end,
    -- it seems that we can only call the firenvim function directly.
    -- Using vim.fn or vim.cmd to call this function will fail.
    build = function()
      local firenvim_path = plugin_dir .. "/firenvim"
      vim.opt.runtimepath:append(firenvim_path)
      vim.cmd("runtime! firenvim.vim")

      -- macOS will reset the PATH when firenvim starts a nvim process, causing the PATH variable to change unexpectedly.
      -- Here we are trying to get the correct PATH and use it for firenvim.
      -- See also https://github.com/glacambre/firenvim/blob/master/TROUBLESHOOTING.md#make-sure-firenvims-path-is-the-same-as-neovims
      local path_env = vim.env.PATH
      local prologue = string.format('export PATH="%s"', path_env)
      -- local prologue = "echo"
      local cmd_str = string.format(":call firenvim#install(0, '%s')", prologue)
      vim.cmd(cmd_str)
    end,
  },
  -- Debugger plugin
  {
    "sakhnik/nvim-gdb",
    enabled = function()
      if vim.g.is_win or vim.g.is_linux then
        return true
      end
      return false
    end,
    build = { "bash install.sh" },
    lazy = true,
  },

  -- Session management plugin
  { "tpope/vim-obsession",   cmd = "Obsession" },

  {
    "ojroques/vim-oscyank",
    enabled = function()
      if vim.g.is_linux then
        return true
      end
      return false
    end,
    cmd = { "OSCYank", "OSCYankReg" },
  },

  -- The missing auto-completion for cmdline!
  {
    "gelguy/wilder.nvim",
    build = ":UpdateRemotePlugins",
  },

  -- showing keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("config.which-key")
    end,
  },

  -- show and trim trailing whitespaces
  { "jdhao/whitespace.nvim", event = "VeryLazy" },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.nvim-tree")
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    tag = "legacy",
    config = function()
      require("config.fidget-nvim")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {},
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
  --     { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --   },
  --   opts = {
  --     debug = true, -- Enable debugging
  --     -- See Configuration section for rest
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   config = function()
  --     require("copilot").setup {}
  --   end,
  -- },
  {
    "smjonas/live-command.nvim",
    -- live-command supports semantic versioning via Git tags
    -- tag = "2.*",
    cmd = "Preview",
    config = function()
      require("config.live-command")
    end,
    event = "VeryLazy",
  },
  {
    -- show hint for code actions, the user can also implement code actions themselves,
    -- see discussion here: https://github.com/neovim/neovim/issues/14869
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup { autocmd = { enabled = true } }
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
  },
  --Neo Man
  {
    "nhooyr/neoman.vim",

    -- Plugin configuration
    config = function()
      -- Basic settings
      vim.g.neoman_find_window = "vnew" -- Open man pages in vertical split
      vim.g.neoman_default_mappings = 1 -- Enable default key mappings

      -- Key mappings for man pages
      vim.api.nvim_set_keymap('n', 'K', ':Man<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Space>m', ':vertical Man<CR>', { noremap = true, silent = true })

      -- Custom commands
      vim.cmd([[
        " Open man page in vertical split
        command! -nargs=* -complete=shellcmd Vman vertical Man <args>

        " Open man page in horizontal split
        command! -nargs=* -complete=shellcmd Sman horizontal Man <args>
      ]])

      -- Highlight settings
      vim.cmd([[
        augroup man_settings
          autocmd!
          autocmd FileType man setlocal number relativenumber
          autocmd FileType man setlocal nowrap
          autocmd FileType man setlocal nolist
          autocmd FileType man setlocal signcolumn=no
          autocmd FileType man setlocal colorcolumn=
        augroup END
      ]])
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = false },
      indent = { enabled = false },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true } -- Wrap notifications
        }
      }
    },
    keys = {
      -- Top Pickers & Explorer
      { "<space><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
      { "<space>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<space>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
      -- { "<space>e", function() Snacks.explorer() end, desc = "File Explorer" },
      -- find
      -- { "<space>fd", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<space>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      -- { "<space>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<space>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
      -- Grep
      { "<space>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      { "<space>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
      { "<space>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<space>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<space>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
      { '<space>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
      { "<space>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
      { "<space>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      { "<space>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<space>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
      { "<space>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<space>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
      { "<space>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
      { "<space>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
      { "<space>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
      { "<space>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
      { "<space>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
      { "<space>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
      { "<space>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
      { "<space>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
      { "<space>sp",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
      { "<space>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      { "<space>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
      { "<space>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
      { "<space>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
      -- LSP
      { "<space>gd",      function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
      { "<space>gD",      function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
      { "<space>gr",      function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
      { "<space>gI",      function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
      { "<space>gy",      function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
      { "<space>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
      { "<space>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
      -- Other
      { "<space>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
      { "<space>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
      { "<space>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
      { "<space>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
      { "<space>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
      { "<space>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
      { "<space>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
      { "<space>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
      { "<space>gg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
      { "<space>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
      {
        "<c-/>",
        function()
          Snacks.terminal({
            shell = zsh_path,
          })
        end,
        desc = "Toggle Terminal"
      },
      { "<c-_>", function() Snacks.terminal() end,                desc = "which_key_ignore" },
      { "]]",    function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",  mode = { "n", "t" } },
      { "[[",    function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",  mode = { "n", "t" } },
      {
        "<space>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      }
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          -- Snacks.toggle.option("spell", { name = "Spelling" }):map("<space>us")
          -- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<space>uw")
          -- Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<space>uL")
          -- Snacks.toggle.diagnostics():map("<space>ud")
          -- Snacks.toggle.line_number():map("<space>ul")
          -- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<space>uc")
          -- Snacks.toggle.treesitter():map("<space>uT")
          -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<space>ub")
          -- Snacks.toggle.inlay_hints():map("<space>uh")
          -- Snacks.toggle.indent():map("<space>ug")
          -- Snacks.toggle.dim():map("<space>uD")
        end,
      })
    end,
  },
  -- {
  --   "vhyrro/luarocks.nvim",
  --   priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
  --   opts = {
  --     rocks = { "lua-toml" }, -- specifies a list of rocks to install
  --     -- luarocks_build_args = { "--with-lua=/my/path" }, -- extra options to pass to luarocks's configuration script
  --   },
  -- },
  { "David-Kunz/gen.nvim" },
  -- competitive programming
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("competitest").setup({
        -- Competitive programming companion plugins integration
        companion_integrated = true,
        companion_move_testcases = true,
        companion_place_in_dir = "./testcases", -- Default directory for cp companion plugin testcases

        -- Runner configuration
        runner = {
          -- How to show the running process output
          -- Values: "split", "quickfix", "notifier", "floating", "toggleterm"
          output_mode = "split",

          -- Split position and size when output_mode is "split"
          split_policy = "vertical",
          split_size = 80,

          -- Floating window settings when output_mode is "floating"
          floating_border = "rounded",
          floating_centered = true,
          floating_width = 0.9, -- percentage of editor width
          floating_height = 0.9, -- percentage of editor height
          floating_x = 0.5, -- percentage of editor width
          floating_y = 0.5, -- percentage of editor height

          -- Auto-close output window when done
          close_on_complete = false,

          -- How much time to wait between consecutive testcases
          testcase_timeout = 200, -- in milliseconds

          -- Control compilation/execution time limits
          compile_timeout = 3000, -- 3 seconds
          run_timeout = 5000, -- 5 seconds
        },

        -- Templates configuration
        template = {
          -- Path to templates directory
          path = vim.fn.stdpath("config") .. "/cp_templates",

          -- Default template when creating a new file
          default = "main.cpp",

          -- Default destination for the created file
          destination = "./",

          -- Map file extensions to template names
          templates_by_extension = {
            cpp = "main.cpp",
            c = "main.c",
            python = "main.py",
            rust = "main.rs",
            java = "Main.java",
          },
        },

        -- Testcases configuration
        testcases = {
          -- Path to testcases directory
          path = "./testcases",

          -- Preferred names for input files
          input_name = "input",

          -- Preferred names for output files
          output_name = "output",

          -- File extensions for testcase files
          input_ext = ".in",
          output_ext = ".out",

          -- Interactive testcase settings
          interactive = {
            active = false,
            timeout = 200, -- ms
          },
        },

        -- Editor configuration
        editor = {
          -- Sequence of prompts for creating testcases
          new_testcase_prompt = "sequential", -- "sequential" or "single"

          -- Preferred editor to edit files
          -- Values: "builtin", "nui", "telescope", "system", "ui_select"
          editor = "builtin",

          -- Delete empty testcases
          delete_empty_testcases = false,
        },

        -- Display configuration
        display = {
          -- Show all paths in selection menu
          show_full_path = false,

          -- How to format testcase titles in selection menu
          testcase_title_format = "%d",

          -- Width/height of selection menu
          ui_select_max_width = 0.9, -- percentage of editor width
          ui_select_max_height = 0.9, -- percentage of editor height
        },

        -- Cache configuration
        cache = {
          -- Values: "json", "sqlite"
          backend = "json",

          -- Path to cache directory
          path = vim.fn.stdpath("cache") .. "/competitest",
        },

        -- Commands that will be used for compilation and execution
        -- Use hardcoded filenames for simplicity and reliability
        compile_command = {
          cpp = { exec = "g++", args = { "-Wall", "-std=c++17", "-o", "main", "main.cpp" } },
          c = { exec = "gcc", args = { "-Wall", "-std=c11", "-o", "main", "main.c" } },
          python = { exec = "", args = {} }, -- Python doesn't need compilation
          java = { exec = "javac", args = { "Main.java" } },
          rust = { exec = "rustc", args = { "-o", "main", "main.rs" } },
        },

        run_command = {
          cpp = { exec = "./main", args = {} },
          c = { exec = "./main", args = {} },
          python = { exec = "python3", args = { "main.py" } },
          java = { exec = "java", args = { "Main" } },
          rust = { exec = "./main", args = {} },
        },

        -- Checker configuration (to validate output)
        -- Using simple diff command with hardcoded approach
        check_command = "diff -u",

        -- Statistics configuration
        stats = {
          -- Automatic time measurement for testcases
          measure_time = true,

          -- Time measurement precision
          time_format = "%.3f", -- 3 decimal places in seconds
        },

        -- Debug configuration
        debug = {
          -- Enable debug mode
          enable = false,

          -- Debug logs location
          log_path = vim.fn.stdpath("cache") .. "/competitest/debug.log",
        },
      })
    end
  },
}

require("lazy").setup {
  spec = plugin_specs,
  ui = {
    border = "rounded",
    title = "Plugin Manager",
    title_pos = "center",
  },
  rocks = {
    enabled = false,
    hererocks = false,
  },
}
