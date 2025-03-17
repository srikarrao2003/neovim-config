-- Configuration for documentation windows with focus control
local function setup_documentation_display()
    -- Configure how documentation floating windows appear
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
            border = "rounded",
            max_width = 80,
            max_height = 20,
            -- Set focusable to false to prevent automatic focus
            focusable = false,
            -- Close documentation when cursor moves
            close_events = {"CursorMoved", "BufLeave", "InsertEnter"}
        }
    )

    -- Configure signature help floating window
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            border = "rounded",
            max_width = 80,
            max_height = 20,
            -- Set focusable to false to prevent automatic focus
            focusable = false,
            close_events = {"CursorMoved", "BufLeave", "InsertEnter"}
        }
    )
end

-- Enhanced keymaps for documentation navigation
local function setup_doc_keymaps()
    -- Show hover documentation without moving cursor
    vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover()
    end, { noremap = true, silent = true })

    -- Show signature help without moving cursor
    vim.keymap.set('n', '<C-k>', function()
        vim.lsp.buf.signature_help()
    end, { noremap = true, silent = true })

    -- If you still want to navigate to the floating window occasionally:
    -- Alt-k to focus the hover window (if it exists)
    vim.keymap.set('n', '<A-k>', function()
        local windows = vim.api.nvim_list_wins()
        for _, win in ipairs(windows) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
            if ft == 'markdown' then
                vim.api.nvim_set_current_win(win)
                return
            end
        end
    end, { noremap = true, silent = true })

    -- Go to definition in new buffer
    vim.keymap.set('n', '<space>gd', function()
        -- Save current position in jump list
        vim.cmd("normal! m'")
        
        -- Get the definition location
        vim.lsp.buf.definition()
        
        -- Create an autocmd that will fire once when the buffer is loaded
        vim.api.nvim_create_autocmd("BufReadPost", {
            callback = function()
                -- Center the screen on the definition
                vim.cmd("normal! zz")
                return true  -- Delete the autocmd after it runs
            end,
            once = true,
        })
    end, { noremap = true, silent = true })

    -- Alt-j to return focus to the code window
    vim.keymap.set('n', '<A-j>', function()
        -- Find and focus the previous code window
        local current_win = vim.api.nvim_get_current_win()
        local windows = vim.api.nvim_list_wins()
        for _, win in ipairs(windows) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
            if ft == 'cpp' or ft == 'c' then
                vim.api.nvim_set_current_win(win)
                return
            end
        end
    end, { noremap = true, silent = true })
end

-- Setup function to be called from init.lua
local M = {}

function M.setup()
    setup_documentation_display()
    setup_doc_keymaps()
end

return M