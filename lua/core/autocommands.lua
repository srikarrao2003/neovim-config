-----------------------------------------------------------
-- Autocommand functions
-----------------------------------------------------------

-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = "500" })
    end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
    pattern = "*",
    command = ":%s/\\s\\+$//e",
})

-- Settings for filetypes:
-- Disable line length marker
augroup("setLineLength", { clear = true })
autocmd("Filetype", {
    group = "setLineLength",
    pattern = {
        "text",
        "html",
        "xhtml",
        "javascript",
        "typescript",
    },
    command = "setlocal cc=0",
})

-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
autocmd("Filetype", {
    group = "setIndent",
    pattern = {
        "xml",
        "html",
        "xhtml",
        "css",
        "scss",
        "javascript",
        "typescript",
        "yaml",
        "lua",
    },
    command = "setlocal shiftwidth=2 tabstop=2",
})

-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
autocmd("Filetype", {
    group = "setIndent",
    pattern = { "c", "cpp", "python", "verilog" },
    command = "setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab",
})

-- Terminal settings:
-- Open a Terminal on the right tab
autocmd("CmdlineEnter", {
    command = "command! Term :botright vsplit term://$SHELL",
})

-- Enter insert mode when switching to terminal
autocmd("TermOpen", {
    command = "setlocal listchars= nonumber norelativenumber nocursorline",
})

autocmd("TermOpen", {
    pattern = "*",
    command = "startinsert",
})

-- Close terminal buffer on process exit
autocmd("BufLeave", {
    pattern = "term://*",
    command = "stopinsert",
})
