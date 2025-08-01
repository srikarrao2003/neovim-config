local status_ok, competitest = pcall(require, "competitest")
if not status_ok then
    return
end

competitest.setup({
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
        cpp = {
            exec = "g++",
            args = {
                "-Wall",
                "-std=c++17",
                "-o",
                "main",
                "main.cpp",
            },
        },
        c = {
            exec = "gcc",
            args = { "-Wall", "-std=c11", "-o", "main", "main.c" },
        },
        python = { exec = "", args = {} }, -- Python doesn't need compilation
        java = { exec = "javac", args = { "Main.java" } },
        rust = {
            exec = "rustc",
            args = { "-o", "main", "main.rs" },
        },
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

-- Optional: Create an easy command to add a predefined template
vim.api.nvim_create_user_command("CompetitestAddTemplate", function(opts)
    local template_name = opts.args
    if template_name == "" then
        print("Please provide a template name")
        return
    end

    local template_dir = vim.fn.stdpath("config") .. "/cp_templates"
    if vim.fn.isdirectory(template_dir) == 0 then
        vim.fn.mkdir(template_dir, "p")
    end

    vim.cmd("edit " .. template_dir .. "/" .. template_name)
end, {
    nargs = 1,
    complete = function(ArgLead, CmdLine, CursorPos)
        return { "main.cpp", "main.py", "main.java", "main.rs", "main.c" }
    end,
})

-- Optional: Create an easy command to add a predefined template
vim.api.nvim_create_user_command("CompetitestAddTemplate", function(opts)
    local template_name = opts.args
    if template_name == "" then
        print("Please provide a template name")
        return
    end

    local template_dir = vim.fn.stdpath("config") .. "/cp_templates"
    if vim.fn.isdirectory(template_dir) == 0 then
        vim.fn.mkdir(template_dir, "p")
    end

    vim.cmd("edit " .. template_dir .. "/" .. template_name)
end, {
    nargs = 1,
    complete = function(ArgLead, CmdLine, CursorPos)
        return { "main.cpp", "main.py", "main.java", "main.rs", "main.c" }
    end,
})

-- run tests
vim.api.nvim_set_keymap("n", ",r", "<cmd>CompetiTest run<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.keymap.set("n", ",a", function()
      local template_path = vim.fn.expand("~/.config/nvim/templates/cpp_boilerplate.cpp")
      vim.cmd("0r " .. template_path)
      vim.cmd("w")
    end, { buffer = true, desc = "Insert and Save C++ Boilerplate" })
  end,
})
