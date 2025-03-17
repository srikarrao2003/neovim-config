--- This module will load a random colorscheme on nvim startup process.

local utils = require("utils")

local M = {}

-- Colorscheme to its directory name mapping, because colorscheme repo name is not necessarily
-- the same as the colorscheme name itself.
M.colorscheme_conf = {
  catppuccin = function()
    -- available option: latte, frappe, macchiato, mocha
    require("catppuccin").setup({
      flavour = "mocha", -- Choose the darkest variant
      background = {
          light = "mocha",
          dark = "mocha",
      },
      transparent_background = false, -- Keep the dark background
      term_colors = true,
      dim_inactive = {
          enabled = false, -- Keep inactive windows vibrant
          shade = "dark",
          percentage = 0.15,
      },
      styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = { "bold" },
          keywords = { "bold" },
          strings = {},
          variables = {},
          numbers = { "bold" },
          booleans = { "bold" },
          properties = {},
          types = { "bold" },
          operators = {},
      },
      integrations = {
          treesitter = true,
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
          },
          telescope = true,
          nvimtree = true,
          gitsigns = true,
          which_key = true,
          indent_blankline = {
              enabled = true,
              colored_indent_levels = true,
          },
      },
      color_overrides = {
          mocha = {
              -- Enhance base colors for more vibrancy
              rosewater = "#f5e0dc",
              flamingo = "#f2cdcd",
              pink = "#f5c2e7",
              mauve = "#cba6f7",
              red = "#f38ba8",
              maroon = "#eba0ac",
              peach = "#fab387",
              yellow = "#f9e2af",
              green = "#a6e3a1",
              teal = "#94e2d5",
              sky = "#89dceb",
              sapphire = "#74c7ec",
              blue = "#89b4fa",
              lavender = "#b4befe",
              text = "#cdd6f4",
              subtext1 = "#bac2de",
              subtext0 = "#a6adc8",
              overlay2 = "#9399b2",
              overlay1 = "#7f849c",
              overlay0 = "#6c7086",
              surface2 = "#585b70",
              surface1 = "#45475a",
              surface0 = "#313244",
              base = "#1e1e2e",
              mantle = "#181825",
              crust = "#11111b",
          },
      },
      highlight_overrides = {
          mocha = function(colors)
              return {
                  -- Enhance specific highlights
                  Normal = { fg = colors.text, bg = colors.base },
                  CursorLine = { bg = colors.surface0 },
                  Visual = { bg = colors.surface2 },
                  Search = { fg = colors.base, bg = colors.yellow },
                  IncSearch = { fg = colors.base, bg = colors.peach },
              }
          end,
      },
    })
    vim.cmd([[colorscheme catppuccin]])
    vim.opt.termguicolors = true
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
