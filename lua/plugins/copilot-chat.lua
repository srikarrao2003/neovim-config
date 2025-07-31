local status_ok, copilot_chat = pcall(require, "CopilotChat")
if not status_ok then
    return
end

copilot_chat.setup({
    debug = false,
    model = "gpt-4.1",
    auto_follow_cursor = false,
    show_help = false,

    -- Window settings
    window = {
      layout = 'vertical',
      width = 0.4,
      height = 0.6,
      row = nil,
      col = nil,
      border = 'rounded',
      title = ' Copilot Chat ',
      footer = nil,
      zindex = 1,
    },

    -- Selection settings
    selection = function(source)
      local select = require("CopilotChat.select")
      return select.visual(source) or select.buffer(source)
    end,

    -- Mappings
    mappings = {
      complete = {
        detail = "Use @<Tab> or /<Tab> for options.",
        insert = '<Tab>',
      },
      close = {
        normal = 'q',
        insert = '<C-c>'
      },
      reset = {
        normal = '<C-r>',
        insert = '<C-r>'
      },
      submit_prompt = {
        normal = '<CR>',
        insert = '<C-CR>'
      },
      accept_diff = {
        normal = '<C-y>',
        insert = '<C-y>'
      },
      yank_diff = {
        normal = 'gy',
        register = '"',
      },
      show_diff = {
        normal = 'gd'
      },
      show_info = {
        normal = 'gp'
      },
      show_context = {
        normal = 'gs'
      },
    },
})

-- Auto commands
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "copilot-chat",
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
})

--Keymaps
local chat = require("CopilotChat")
local select = require("CopilotChat.select")

-- Main keymaps
vim.keymap.set("n", "<space>cc", function()
    chat.toggle()
end, { desc = "Toggle Copilot Chat" })
vim.keymap.set("v", "<space>cc", function()
    chat.toggle()
end, { desc = "Toggle Copilot Chat" })
vim.keymap.set("n", "<space>cr", function()
    chat.reset()
end, { desc = "Reset Chat" })

-- Quick actions
vim.keymap.set("v", "<space>ce", function()
  chat.ask("Explain this code", { selection = select.visual })
end, { desc = "Explain Code" })

vim.keymap.set("v", "<space>cf", function()
  chat.ask("Fix this code", { selection = select.visual })
end, { desc = "Fix Code" })

vim.keymap.set("v", "<space>co", function()
  chat.ask("Optimize this code", { selection = select.visual })
end, { desc = "Optimize Code" })

vim.keymap.set("v", "<space>ct", function()
  chat.ask("Write tests for this code", { selection = select.visual })
end, { desc = "Generate Tests" })

vim.keymap.set("v", "<space>cd", function()
  chat.ask("Add documentation for this code", { selection = select.visual })
end, { desc = "Add Documentation" })

-- Buffer/file actions
vim.keymap.set("n", "<space>cb", function()
  chat.ask("Analyze this entire buffer", { selection = select.buffer })
end, { desc = "Analyze Buffer" })

-- Custom prompts
vim.keymap.set("n", "<space>cp", function()
  local input = vim.fn.input("Ask Copilot: ")
  if input ~= "" then
    chat.ask(input)
  end
end, { desc = "Custom Prompt" })

