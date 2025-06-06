--- This module will load a random colorscheme on nvim startup process.

local utils = require("utils")

local M = {}

-- Colorscheme to its directory name mapping, because colorscheme repo name is not necessarily
-- the same as the colorscheme name itself.
M.colorscheme_conf = {
  catppuccin = function()
    -- available option: latte, frappe, macchiato, mocha
    require("catppuccin").setup({
      integrations = {
          aerial = true,
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          hop = false,
          treesitter = true,
          treesitter_context = true,
          which_key = false,
          notify = true,
          mason = true,
          markdown = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          symbols_outline = true,
          native_lsp = {
              enabled = true,
              virtual_text = {
                  errors = { "italic" },
                  hints = { "italic" },
                  warnings = { "italic" },
                  information = { "italic" },
              },
              underlines = {
                  errors = { "underline" },
                  hints = { "underline" },
                  warnings = { "underline" },
                  information = { "underline" },
              },
              inlay_hints = {
                 background = true,
              },
          },
          navic = {
              enabled = true,
              custom_bg = "NONE",
          },
      },
    })
    -- vim.cmd.colorscheme("catppuccin")
    vim.cmd.colorscheme("onedark_dark")

    vim.cmd([[highlight! Visual guibg=#505783 gui=nocombine]])
  end,
}

--- Use a random colorscheme from the pre-defined list of colorschemes.
M.rand_colorscheme = function()
  local colorscheme = utils.rand_element(vim.tbl_keys(M.colorscheme_conf))

  if not vim.tbl_contains(vim.tbl_keys(M.colorscheme_conf), colorscheme) then
    local msg = "Invalid colorscheme: " .. colorscheme
    vim.notify(msg, vim.log.levels.ERROR, { title = "nvim-config" })

    return
  end

  -- Load the colorscheme and its settings
  M.colorscheme_conf[colorscheme]()

  if vim.g.logging_level == "debug" then
    local msg = "Colorscheme: " .. colorscheme

    vim.notify(msg, vim.log.levels.DEBUG, { title = "nvim-config" })
  end
end

-- Load a random colorscheme
M.rand_colorscheme()
