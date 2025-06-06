local keymap = vim.keymap
local uv = vim.uv

-- Save key strokes (now we do not need to press shift to enter command mode).
keymap.set({ "n", "x" }, ";", ":")

-- Turn the word under cursor to upper case
keymap.set("i", "<c-u>", "<Esc>viwUea")

-- Turn the current word into title case
keymap.set("i", "<c-t>", "<Esc>b~lea")

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
keymap.set("n", "<leader>p", "m`o<ESC>p``", { desc = "paste below current line" })
keymap.set("n", "<leader>P", "m`O<ESC>p``", { desc = "paste above current line" })

-- Shortcut for faster save and quit
keymap.set("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "save buffer" })

-- Quit all opened buffers
keymap.set("n", "<space>q", "<cmd>qa<cr>", { silent = true, desc = "quit current window" })

-- Saves the file if modified and quit
keymap.set("n", "<leader>Q", "<cmd>x<cr>", { silent = true, desc = "quit nvim" })

-- Navigation in the location and quickfix list
keymap.set("n", "[l", "<cmd>lprevious<cr>zv", { silent = true, desc = "previous location item" })
keymap.set("n", "]l", "<cmd>lnext<cr>zv", { silent = true, desc = "next location item" })

keymap.set("n", "[L", "<cmd>lfirst<cr>zv", { silent = true, desc = "first location item" })
keymap.set("n", "]L", "<cmd>llast<cr>zv", { silent = true, desc = "last location item" })

keymap.set("n", "[q", "<cmd>cprevious<cr>zv", { silent = true, desc = "previous qf item" })
keymap.set("n", "]q", "<cmd>cnext<cr>zv", { silent = true, desc = "next qf item" })

keymap.set("n", "[Q", "<cmd>cfirst<cr>zv", { silent = true, desc = "first qf item" })
keymap.set("n", "]Q", "<cmd>clast<cr>zv", { silent = true, desc = "last qf item" })

-- Close location list or quickfix list if they are present, see https://superuser.com/q/355325/736190
keymap.set("n", [[\x]], "<cmd>windo lclose <bar> cclose <cr>", {
  silent = true,
  desc = "close qf and location list",
})

-- Delete a buffer, without closing the window, see https://stackoverflow.com/q/4465095/6064933
keymap.set("n", [[\d]], "<cmd>bprevious <bar> bdelete #<cr>", {
  silent = true,
  desc = "delete current buffer",
})

keymap.set("n", [[\D]], function()
  local buf_ids = vim.api.nvim_list_bufs()
  local cur_buf = vim.api.nvim_win_get_buf(0)

  for _, buf_id in pairs(buf_ids) do
    -- do not Delete unlisted buffers, which may lead to unexpected errors
    if vim.api.nvim_get_option_value("buflisted", { buf = buf_id }) and buf_id ~= cur_buf then
      vim.api.nvim_buf_delete(buf_id, { force = true })
    end
  end
end, {
  desc = "delete other buffers",
})

-- Insert a blank line below or above current line (do not move the cursor),
-- see https://stackoverflow.com/a/16136133/6064933
keymap.set("n", "<space>o", "printf('m`%so<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})

keymap.set("n", "<space>O", "printf('m`%sO<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line above",
})

-- Move the cursor based on physical lines, not the actual lines.
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap.set("n", "^", "g^")
keymap.set("n", "0", "g0")

-- Do not include white space characters when using $ in visual mode,
-- see https://vi.stackexchange.com/q/12607/15292
keymap.set("x", "$", "g_")

-- Go to start or end of line easier
keymap.set({ "n", "x" }, "H", "^")
keymap.set({ "n", "x" }, "L", "g_")

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

-- Edit and reload nvim config file quickly
keymap.set("n", "<leader>ev", "<cmd>tabnew $MYVIMRC <bar> tcd %:h<cr>", {
  silent = true,
  desc = "open init.lua",
})

keymap.set("n", "<leader>sv", function()
  vim.cmd([[
      update $MYVIMRC
      source $MYVIMRC
    ]])
  vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
end, {
  silent = true,
  desc = "reload init.lua",
})

-- Reselect the text that has just been pasted, see also https://stackoverflow.com/a/4317090/6064933.
keymap.set("n", "<leader>v", "printf('`[%s`]', getregtype()[0])", {
  expr = true,
  desc = "reselect last pasted area",
})

-- Always use very magic mode for searching
keymap.set("n", "/", [[/\v]])

-- Search in selected region
-- xnoremap / :<C-U>call feedkeys('/\%>'.(line("'<")-1).'l\%<'.(line("'>")+1)."l")<CR>

-- Change current working directory locally and print cwd after that,
-- see https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
keymap.set("n", "<leader>cd", "<cmd>lcd %:p:h<cr><cmd>pwd<cr>", { desc = "change cwd" })

-- -- Use Esc to quit builtin terminal
-- keymap.set("t", "<Esc>", [[<c-\><c-n>]])

-- Toggle spell checking
keymap.set("n", "<F11>", "<cmd>set spell!<cr>", { desc = "toggle spell" })
keymap.set("i", "<F11>", "<c-o><cmd>set spell!<cr>", { desc = "toggle spell" })

-- Change text without putting it into the vim register,
-- see https://stackoverflow.com/q/54255/6064933
keymap.set("n", "c", '"_c')
keymap.set("n", "C", '"_C')
keymap.set("n", "cc", '"_cc')
keymap.set("x", "c", '"_c')

-- Remove trailing whitespace characters
keymap.set("n", "<leader><space>", "<cmd>StripTrailingWhitespace<cr>", { desc = "remove trailing space" })

-- check the syntax group of current cursor position
keymap.set("n", "<leader>st", "<cmd>call utils#SynGroup()<cr>", { desc = "check syntax group" })

-- Copy entire buffer.
keymap.set("n", "<leader>y", "<cmd>%yank<cr>", { desc = "yank entire buffer" })

-- Toggle cursor column
keymap.set("n", "<leader>cl", "<cmd>call utils#ToggleCursorCol()<cr>", { desc = "toggle cursor column" })

-- Move current line up and down
keymap.set("n", "<A-k>", '<cmd>call utils#SwitchLine(line("."), "up")<cr>', { desc = "move line up" })
keymap.set("n", "<A-j>", '<cmd>call utils#SwitchLine(line("."), "down")<cr>', { desc = "move line down" })

-- Move current visual-line selection up and down
keymap.set("x", "<A-k>", '<cmd>call utils#MoveSelection("up")<cr>', { desc = "move selection up" })

keymap.set("x", "<A-j>", '<cmd>call utils#MoveSelection("down")<cr>', { desc = "move selection down" })

-- Replace visual selection with text in register, but not contaminate the register,
-- see also https://stackoverflow.com/q/10723700/6064933.
keymap.set("x", "p", '"_c<Esc>p')

-- Go to a certain buffer
keymap.set("n", "gb", '<cmd>call buf_utils#GoToBuffer(v:count, "forward")<cr>', {
  desc = "go to buffer (forward)",
})
keymap.set("n", "gB", '<cmd>call buf_utils#GoToBuffer(v:count, "backward")<cr>', {
  desc = "go to buffer (backward)",
})

-- Switch windows
keymap.set("n", "<left>", "<c-w>h")
keymap.set("n", "<Right>", "<C-W>l")
keymap.set("n", "<Up>", "<C-W>k")
keymap.set("n", "<Down>", "<C-W>j")

-- Text objects for URL
keymap.set({ "x", "o" }, "iu", "<cmd>call text_obj#URL()<cr>", { desc = "URL text object" })

-- Text objects for entire buffer
keymap.set({ "x", "o" }, "iB", ":<C-U>call text_obj#Buffer()<cr>", { desc = "buffer text object" })

-- Do not move my cursor when joining lines.
keymap.set("n", "J", function()
  vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

keymap.set("n", "gJ", function()
  -- we must use `normal!`, otherwise it will trigger recursive mapping
  vim.cmd([[
      normal! mzgJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

-- Break inserted text into smaller undo units when we insert some punctuation chars.
local undo_ch = { ",", ".", "!", "?", ";", ":" }
for _, ch in ipairs(undo_ch) do
  keymap.set("i", ch, ch .. "<c-g>u")
end

-- insert semicolon in the end
keymap.set("i", "<A-;>", "<Esc>miA;<Esc>`ii")

-- Go to the beginning and end of current line in insert mode quickly
keymap.set("i", "<C-A>", "<HOME>")
keymap.set("i", "<C-E>", "<END>")

-- Go to beginning of command in command-line mode
keymap.set("c", "<C-A>", "<HOME>")

-- Delete the character to the right of the cursor
keymap.set("i", "<C-D>", "<DEL>")

keymap.set("n", "<leader>cb", function()
  local cnt = 0
  local blink_times = 7
  local timer = uv.new_timer()
  if timer == nil then
    return
  end

  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      vim.cmd([[
      set cursorcolumn!
      set cursorline!
    ]])

      if cnt == blink_times then
        timer:close()
      end

      cnt = cnt + 1
    end)
  )
end, { desc = "show cursor" })

--toggleterm mappings

--Open Float Terminal
vim.api.nvim_set_keymap('n', '<Space>t', "<cmd>ToggleTerm direction=float<cr>",
  { noremap = true, silent = true }
)

-- Terminal specific keymaps
function _G.set_terminal_keymaps()
  local opts = { buffer = true }
  -- Escape terminal mode to normal mode with Esc
  vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
end

-- Auto-set terminal keymaps when terminal opens
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')


-- Buffer mappings

-- Buffer format keymap
vim.keymap.set("n", "<Space>bf", function()
  vim.lsp.buf.format({ async = true })
end, { noremap = true, silent = true, desc = "Format buffer" })


-- Buffer delete
vim.api.nvim_set_keymap('n', '<Space>bd', "<cmd>bprevious <bar> bdelete #<cr>", { noremap = true, silent = true })

-- Buffer shift
vim.api.nvim_set_keymap('n', '<Space>bs', ':bnext<CR>', { noremap = true, silent = true })

-- Buffer prev
vim.api.nvim_set_keymap('n', '<Space>bp', ':bprev<CR>', { noremap = true, silent = true })

-- NvimTree Mappings

-- Toggle to nvimtree from buffer

vim.keymap.set("n", "<Space>o", ":NvimTreeFocus<CR>", { noremap = true, silent = true })

-- Toggle to buffer from neotree

vim.keymap.set("n", "<Space>i", ":wincmd p<CR>", { noremap = true, silent = true })

-- Replace All Uses with shortcut

vim.keymap.set("n", "<Space>rr", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { noremap = true, silent = true })

-- Removes default yanking while deleting the text

vim.keymap.set({ 'n', 'x' }, 'd', '"_d', { desc = "Delete without yanking" })

-- Telescope mappings

-- Key mappings for fuzzy searching in floating windows
vim.api.nvim_set_keymap('n', '<Space>ff',
  [[:lua require('telescope.builtin').find_files({ layout_strategy = 'vertical' })<CR>]],
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>fh',
  [[:lua require('telescope.builtin').help_tags({ layout_strategy = 'vertical' })<CR>]],
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>fg',
  [[:lua require('telescope.builtin').live_grep({ layout_strategy = 'vertical' })<CR>]],
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>ft', ':Leaderf bufTag --popup<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>fd',
  [[:lua require('telescope.builtin').buffers({ layout_strategy = 'vertical' })<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>fw',
  [[:lua require('telescope.builtin').current_buffer_fuzzy_find({ layout_strategy = 'vertical' })<CR>]],
  { noremap = true, silent = true })


-- Diagnostics
-- vim.keymap.set('n', '<Space>x', vim.diagnostic.open_float, opts)                 -- Show diagnostics
-- vim.keymap.set('n', 'xN', vim.diagnostic.goto_prev, opts)                         -- Previous diagnostic
vim.keymap.set('n', '<Space>x', vim.diagnostic.goto_next, opts) -- Next diagnostic

--Lazygit
vim.keymap.set('n', '<Space>gl', ":LazyGit<CR>", { noremap = true, silent = true })

--Code action
vim.keymap.set('n', '<Space>la', vim.lsp.buf.code_action, { desc = 'Code Action' })

--Telescope diagnostics
vim.keymap.set('n', '<Space>ld', "<cmd>Telescope diagnostics<CR>", { desc = 'Telescope diagnostics' })


-- Keymaps for improved horizontal & vertical movement in Neovim
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Vertical movements
keymap("n", "<C-d>", "<C-d>zz", opts) -- Scroll half-page down & center
keymap("n", "<C-u>", "<C-u>zz", opts) -- Scroll half-page up & center


-- Horizontal movements
keymap("n", "H", "^", opts)  -- Move to first non-blank character
keymap("n", "L", "$", opts)  -- Move to end of line
keymap("n", "W", "5w", opts) -- Move 5 words forward
keymap("n", "B", "5b", opts) -- Move 5 words backward

-- Smooth scrolling
keymap("n", "<C-e>", "2<C-e>", opts) -- Scroll down faster
keymap("n", "<C-y>", "2<C-y>", opts) -- Scroll up faster

-- Show full file path with <space>fp
vim.keymap.set('n', '<space>fp', function()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
  print(vim.fn.expand('%:p'))
end, { desc = "Print full file path" })

-- Function to replace a word in the entire workspace
-- Requires telescope.nvim plugin
local function replace_word_in_workspace()
  -- Get the word under cursor
  local word = vim.fn.expand('<cword>')

  -- Prompt for the replacement
  local replacement = vim.fn.input('Replace "' .. word .. '" with: ')

  -- If user cancelled or provided empty replacement, abort
  if replacement == '' then
    vim.notify('Replacement cancelled', vim.log.levels.INFO)
    return
  end

  -- Confirm before proceeding
  local confirm = vim.fn.input('Replace all occurrences of "' .. word .. '" with "' .. replacement .. '"? (y/n): ')
  if confirm:lower() ~= 'y' then
    vim.notify('Replacement cancelled', vim.log.levels.INFO)
    return
  end

  -- Use telescope to search for the word in the workspace and create a quickfix list
  vim.cmd('Telescope grep_string search=' .. word)

  -- Wait for user to populate the quickfix list by selecting files in telescope
  vim.notify('Select files in Telescope and press <C-q> to add to quickfix list, then press <Esc>', vim.log.levels.INFO)

  -- After user has populated quickfix list, set up an autocmd to perform the replacement
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
      vim.keymap.set("n", "<space>rp", function()
        vim.cmd('cdo %s/' .. word .. '/' .. replacement .. '/gc')
        vim.notify('Replacement completed!', vim.log.levels.INFO)
      end, { buffer = true })
      vim.notify('Press <space>rp in quickfix window to perform replacements', vim.log.levels.INFO)
    end,
    once = true,
  })
end

-- Map the function to <space>re
vim.keymap.set('n', '<space>re', replace_word_in_workspace,
  { noremap = true, silent = true, desc = 'Replace word in workspace' })

-- Gen
vim.keymap.set({ 'n', 'v' }, '<space>w', ':Gen<CR>')

-- Tmux navigation maps
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { noremap = true, silent = true })

-- move across function setting
vim.api.nvim_set_keymap('n', 'm', '}', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'M', '{', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 't', '%')

--delete everything in the buffer
vim.keymap.set("n", "<space>d", "gg0vG$d", { desc = "Delete Everthing in Buffer" })

-- copy line
vim.api.nvim_set_keymap('n', 'yL', 'y$', { noremap = true, silent = true })

vim.keymap.set('n', 'o', 'o <BS>', { noremap = true })

-- rename across project
vim.keymap.set("n", "<space>rw", "<cmd>Lspsaga rename<CR>", { desc = "Rename symbol" })
vim.keymap.set("n", "<space>R", "<cmd>Lspsaga rename ++project<CR>", { desc = "Rename symbol (project-wide)" })

-- competitive programming
-- Run tests
vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>CompetiTest run<CR>", opts)
-- vim.api.nvim_set_keymap("i", "<F9>", "<ESC><cmd>CompetiTest run<CR>", opts)

-- Add testcase
vim.api.nvim_set_keymap("n", "<space>aa", "<cmd>CompetiTest add_testcase<CR>", opts)

-- Edit testcase
vim.api.nvim_set_keymap("n", "<space>ae", "<cmd>CompetiTest edit_testcase<CR>", opts)

-- Delete testcase
vim.api.nvim_set_keymap("n", "<space>ad", "<cmd>CompetiTest delete_testcase<CR>", opts)

-- Create a template file
vim.api.nvim_set_keymap("n", "<space>ac", "<cmd>CompetiTest template<CR>", opts)

-- Show results
vim.api.nvim_set_keymap("n", "<space>ar", "<cmd>CompetiTest show_ui<CR>", opts)

-- Command to quickly edit competitest configuration
vim.api.nvim_create_user_command('CompetiTestEditConfig', function()
  vim.cmd('edit ' .. vim.fn.stdpath("config") .. '/lua/competitest.lua')
end, {})

-- Optional: Create an easy command to add a predefined template
vim.api.nvim_create_user_command('CompetitestAddTemplate', function(opts)
  local template_name = opts.args
  if template_name == "" then
    print("Please provide a template name")
    return
  end

  local template_dir = vim.fn.stdpath("config") .. "/cp_templates"
  if vim.fn.isdirectory(template_dir) == 0 then
    vim.fn.mkdir(template_dir, "p")
  end

  vim.cmd('edit ' .. template_dir .. '/' .. template_name)
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    return { "main.cpp", "main.py", "main.java", "main.rs", "main.c" }
  end
})
