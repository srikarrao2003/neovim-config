local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<space>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    a = {
        name = "Competitive Programming",
        a = { "<cmd>CompetiTest add_testcase<CR>" , "Add test case" },
        c = { "<cmd>CompetiTest template<CR>" , "Template" },
        e = { "<cmd>CompetiTest edit_testcase<CR>" , "Edit test case" },
        d = { "<cmd>CompetiTest delete_testcase<CR>" , "Delete testcase" },
        r = { "<cmd>CompetiTest show_ui<CR>" , "Show UI" },
    },
    b = {
        name = "Buffers",
        b = {
            "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
            "List Buffers",
        },
        d = {
            "<cmd>bprevious <bar> bdelete #<cr>",
            "Delete current buffer",
        },
        f = { "<cmd>Format<cr>", "Format" },
        o = {
            ":lua require('bufdel').delete_buffer_others()<cr>",
            "Close Other Buffers",
        },
        p = {
            ":BufferLinePick<CR>",
            "Buffer Pick",
        },
    },
    ["c"] = {
        "<cmd>e ~/.config/nvim/init.lua<CR>",
        "Open NVIM Config",
    },
    ["e"] = {
        "<cmd>:keepjumps NvimTreeFindFileToggle<CR>",
        "Toggle File Explorer",
    },
    ["o"] = {
        "<cmd>:NvimTreeFocus<CR>",
        "Nvim Tree Focus",
    },
    ["h"] = { ":nohl<CR>", "No Highlight" },
    ["i"] = { ":wincmd p<CR>", "Switch To Buffer" },
    ["q"] = { "<cmd>qa<cr>", "Close All Windows" },

    f = {
        name = "Telescope",
        f = {":lua require('telescope.builtin').find_files({ layout_strategy = 'vertical' })<CR>",
            "Find Files"},
        g = {":lua require('telescope.builtin').live_grep({ layout_strategy = 'vertical' })<CR>",
            "Live Grep"},
        d = {":lua require('telescope.builtin').buffers({ layout_strategy = 'vertical' })<CR>",
            "Find Buffers"},
        h = { "<cmd>lua require'telescope.builtin'.find_files({hidden=true})<CR>", "Find Hidden Files" },
    },

    g = {
        name = "Git",
        g = { "<cmd>LazyGit<CR>", "LazyGit" },
        j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
        k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
        l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
        p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        d = {
            function()
                vim.cmd("split | wincmd T | lua require'gitsigns'.diffthis()")
                vim.cmd("wincmd h")
            end,
            "Diff",
        },
    },

    l = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        d = {
            "<cmd>Telescope diagnostics<cr>",
            "Document Diagnostics",
        },
        i = { "<cmd>LspInfo<cr>", "Info" },
        I = { "<cmd>Mason<cr>", "Installer Info" },
        j = {
            "<cmd>lua vim.diagnostic.goto_next()<CR>",
            "Next Diagnostic",
        },
        k = {
            "<cmd>lua vim.diagnostic.goto_prev()<cr>",
            "Prev Diagnostic",
        },
        l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        s = { "<cmd>Lspsaga outline<CR>", "Lspsaga Outline" },
        S = {
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace Symbols",
        },
        g = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature" },
        p = { "<cmd>Lspsaga peek_definition<CR>", "Peek Definition" },
        q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Local List" },
        o = { "<cmd>Lspsaga finder<CR>", "Lspsaga Finder "},
        t = { "<cmd>TodoTelescope<CR>", "Project TODO comments" },
    },
    s = {
        name = "Search",
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<cr>", "Colourscheme" },
        h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        C = { "<cmd>Telescope commands<cr>", "Commands" },
    },

    t = {
        "<cmd>ToggleTerm direction=float<cr>",
        "Toggle Float Terminal",
    },

    ["v"] = { "<cmd>AerialToggle<CR>", "Symbols Outline" },
    ["m"] = {
        require("plugins.markdown-preview").execute,
        "Markdown Preview Toggle",
    },

    j = {
        name = "Debugger",
        d = { "<cmd>lua require('dapui').toggle()<CR>", "Show Debug Panel" },

        E = {
            "<cmd>lua require('dapui').eval(vim.fn.input '[Expression] > ')<cr>",
            "Evaluate Input",
        },
        C = {
            "<cmd>lua require('dap').set_breakpoint(vim.fn.input '[Condition] > ')<cr>",
            "Conditional Breakpoint",
        },
        H = { "<cmd>lua require('dap').step_back()<cr>", "Step Back" },
        c = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
        r = { "<cmd>lua require('dap').continue()<cr>", "Run" },
        K = {
            "<cmd>lua require('dap.ui.widgets').hover()<cr>",
            "Hover Variables",
        },
        S = { "<cmd>lua require('dap.ui.widgets').scopes()<cr>", "Scopes" },
        s = { "<cmd>lua require('dap').step_into()<cr>", "Step Into" },
        n = { "<cmd>lua require('dap').step_over()<cr>", "Step Over" },
        q = { "<cmd>lua require('dap').close()<cr>", "Quit" },
        b = {
            "<cmd>lua require('dap').toggle_breakpoint()<cr>",
            "Toggle Breakpoint",
        },
        x = { "<cmd>lua require('dap').terminate()<cr>", "Terminate" },
        f = { "<cmd>lua require('dap').step_out()<cr>", "Step Out" },
        -- Python
        p = {
            name = "Python",
            m = {
                "<cmd>lua require('dap-python').test_method()<CR><ESC>l",
                "Test method",
            },
            c = {
                "<cmd>lua require('dap-python').test_class()<CR><ESC>l",
                "Test class",
            },
        },
    },
    r = {
        name = "Symbol Rename types",
        w = { "<cmd>Lspsaga rename<CR>", "Rename Symbol" },
        r = { "<cmd>Lspsaga rename ++project<CR>" },
    },
    ["x"] = {"<cmd>lua vim.diagnostic.goto_next()<CR>",
            "Next Diagnostic",
    },
    ["X"] = {"<cmd>lua vim.diagnostic.goto_prev()<CR>",
            "Prev Diagnostic",
    },
    ["z"] = { "<cmd>ZenMode<CR>", "Zen Mode" },
}

which_key.setup(setup)
which_key.register(mappings, opts)
