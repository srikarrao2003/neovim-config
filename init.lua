-- This is my personal Nvim configuration supporting Mac, Linux and Windows, with various plugins configured.
-- This configuration evolves as I learn more about Nvim and become more proficient in using Nvim.
-- Since it is very long (more than 1000 lines!), you should read it carefully and take only the settings that suit you.
-- I would not recommend cloning this repo and replace your own config. Good configurations are personal,
-- built over time with a lot of polish.
--
-- Author: Jiedong Hao
-- Email: jdhao@hotmail.com
-- Blog: https://jdhao.github.io/
-- GitHub: https://github.com/jdhao
-- StackOverflow: https://stackoverflow.com/users/6064933/jdhao
vim.loader.enable()

local utils = require("utils")

-- local expected_version = "0.10.3"
-- utils.is_compatible_version(expected_version)

local config_dir = vim.fn.stdpath("config")
---@cast config_dir string

-- some global settings
require("globals")
-- setting options in nvim
vim.cmd("source " .. vim.fs.joinpath(config_dir, "viml_conf/options.vim"))
-- various autocommands
require("custom-autocmd")
-- all the user-defined mappings
require("mappings")
-- all the plugins installed and their configurations
vim.cmd("source " .. vim.fs.joinpath(config_dir, "viml_conf/plugins.vim"))
-- colorscheme settings
require("colorschemes")
-- man Info
require("man").setup()
-- handlers
require("handlers").setup()
-- llm
require("llm").setup()

vim.cmd([[
  augroup CHeaderFiletype
    autocmd!
    autocmd BufRead,BufNewFile *.h set filetype=c
  augroup END
]])

vim.cmd([[
  augroup mlirSyntax
    autocmd!
    autocmd BufNewFile,BufRead *.mlir set filetype=mlir
  augroup END
]])

vim.cmd([[
  highlight RainbowDelimiterRed guifg=#E06C75
  highlight RainbowDelimiterYellow guifg=#E5C07B
  highlight RainbowDelimiterBlue guifg=#61AFEF
  highlight RainbowDelimiterOrange guifg=#D19A66
  highlight RainbowDelimiterGreen guifg=#98C380
  highlight RainbowDelimiterViolet guifg=#C678DD
  highlight RainbowDelimiterCyan guifg=#56B6C2
]])

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = function()
    vim.cmd('TSEnable highlight')
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.keymap.set("n", "<leader>a", function()
      local template_path = vim.fn.expand("~/.config/nvim/templates/cpp_boilerplate.cpp")
      vim.cmd("0r " .. template_path)
      vim.cmd("w")
    end, { buffer = true, desc = "Insert and Save C++ Boilerplate" })
  end,
})


-- Enable mouse
vim.opt.mouse = "a"
vim.o.scroll = 20

vim.g.python_highlight_all = 1

-- Smooth mouse Scroll
vim.keymap.set("n", "<ScrollWheelUp>", "3<C-Y>", { noremap = true, silent = true })
vim.keymap.set("n", "<ScrollWheelDown>", "3<C-E>", { noremap = true, silent = true })

vim.opt.clipboard = "unnamedplus"
