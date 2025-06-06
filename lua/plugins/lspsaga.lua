local status_ok, saga = pcall(require, "lspsaga")
if not status_ok then
    return
end

saga.setup({
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
