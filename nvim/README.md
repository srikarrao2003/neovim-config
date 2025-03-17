
# Introduction

This repo hosts my Nvim configuration for Linux.
`init.lua` is the config entry point for terminal Nvim,
and `ginit.vim` is the additional config file for GUI client of Nvim.

My configurations are heavily documented to make it as clear as possible.
While you can clone the whole repository and use it, it is not recommended though.
Good configurations are personal. Everyone should have his or her unique config file.
You are encouraged to copy from this repo the part you want and add it to your own config.

**Note** : Most of my code was inspired by `jdhao/nvim-config` github repository

No effort is spent on maintaining backward compatibility.**

# Install and setup

See [doc here](docs/README.md) on how to install Nvim's dependencies, Nvim itself,
and how to set up on different platforms (Linux, macOS, and Windows).

**Note** : Since rushmore doesnot have internet access, you can create a virtual env of python version 3.11(preferred)
to install all the required pip installations. Here are the pip and npm installations that I have added to setup the virtual env:

## Pip Installations

+ `pynvim`
+ `python-lsp-server`
+ `vim-vint`
+ `python-lsp-isort`
+ `pylsp-mypy`
+ `python-lsp-black`
+ `cpplint`(optional)
+ `pyright`

## Npm Installations

+ npm install -g vim-language-server
+ npm install -g bash-language-server

**Note** : Preferred Version of Nvim is `v0.11`. You can get other executables from `/local/nsrikarrao/.local/bin`


# Features #

+ Plugin management via [Lazy.nvim](https://github.com/folke/lazy.nvim).
+ Code, snippet, word auto-completion via [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).
+ Language server protocol (LSP) support via [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).
+ Git integration via [vim-fugitive](https://github.com/tpope/vim-fugitive).
+ Better escaping from insert mode via [better-escape.vim](https://github.com/nvim-zh/better-escape.vim).
+ Ultra-fast project-wide fuzzy searching via [LeaderF](https://github.com/Yggdroot/LeaderF).
+ Faster code commenting via [vim-commentary](https://github.com/tpope/vim-commentary).
+ Faster matching pair insertion and jump via [nvim-autopairs](https://github.com/windwp/nvim-autopairs).
+ Smarter and faster matching pair management (add, replace or delete) via [vim-sandwich](https://github.com/machakann/vim-sandwich).
+ Fast buffer jump via [hop.nvim](https://github.com/phaazon/hop.nvim).
+ Powerful snippet insertion via [Ultisnips](https://github.com/SirVer/ultisnips).
+ Beautiful statusline via [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim).
+ File tree explorer via [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua).
+ Better quickfix list with [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf).
+ Show search index and count with [nvim-hlslens](https://github.com/kevinhwang91/nvim-hlslens).
+ Command line auto-completion via [wilder.nvim](https://github.com/gelguy/wilder.nvim).
+ User-defined mapping hint via [which-key.nvim](https://github.com/folke/which-key.nvim).
+ Asynchronous code execution via [asyncrun.vim](https://github.com/skywind3000/asyncrun.vim).
+ Code highlighting via [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).
+ Code editing using true nvim inside browser via [firenvim](https://github.com/glacambre/firenvim).
+ Beautiful colorscheme via [sainnhe/gruvbox-material](https://github.com/sainnhe/gruvbox-material) and other colorschemes.
+ Markdown writing and previewing via [vim-markdown](https://github.com/preservim/vim-markdown) and [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim).
+ LaTeX editing and previewing via [vimtex](https://github.com/lervag/vimtex)
+ Animated GUI style notification via [nvim-notify](https://github.com/rcarriga/nvim-notify).
+ Tags navigation via [vista](https://github.com/liuchengxu/vista.vim).
+ Code formatting via [Neoformat](https://github.com/sbdchd/neoformat).
+ Undo management via [vim-mundo](https://github.com/simnalamburt/vim-mundo)
+ Code folding with [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) and [statuscol.nvim](https://github.com/luukvbaal/statuscol.nvim)
+ ......


# Shortcuts

Some of the shortcuts I use frequently are listed here. In the following shortcuts, `<leader>` represents ASCII character `,`.

**Note** : I prefer to use `<space>` as my default leader key. So all the customized keys starting with `<space>` were added for my convenience.

| Shortcut          | Mode          | platform        | Description                                                              |
|-------------------|---------------|-----------------|--------------------------------------------------------------------------|
| `<leader>ff`      | Normal        | Linux/macOS/Win | Fuzzy file searching in a floating window                                |
| `<leader>fh`      | Normal        | Linux/macOS/Win | Fuzzy help file grepping in a floating window                            |
| `<leader>fg`      | Normal        | Linux/macOS/Win | Fuzzy project-wide grepping in a floating window                         |
| `<leader>ft`      | Normal        | Linux/macOS/Win | Fuzzy buffer tag searching in a floating window                          |
| `<leader>fb`      | Normal        | Linux/macOS/Win | Fuzzy buffer switching in a floating window                              |
| `<leader><Space>` | Normal        | Linux/macOS/Win | Remove trailing white spaces                                             |
| `<leader>v`       | Normal        | Linux/macOS/Win | Reselect last pasted text                                                |
| `<leader>ev`      | Normal        | Linux/macOS/Win | Edit Nvim config in a new tabpage                                        |
| `<leader>sv`      | Normal        | Linux/macOS/Win | Reload Nvim config                                                       |
| `<leader>st`      | Normal        | Linux/macOS/Win | Show highlight group for cursor text                                     |
| `<leader>q`       | Normal        | Linux/macOS/Win | Quit current window                                                      |
| `<leader>Q`       | Normal        | Linux/macOS/Win | Quit all window and close Nvim                                           |
| `<leader>w`       | Normal        | Linux/macOS/Win | Save current buffer content                                              |
| `<leader>y`       | Normal        | Linux/macOS/Win | Copy the content of entire buffer to default register                    |
| `<leader>cl`      | Normal        | Linux/macOS/Win | Toggle cursor column                                                     |
| `<leader>cd`      | Normal        | Linux/macOS/Win | Change current working directory to to the dir of current buffer         |
| `<space>t`        | Normal        | Linux/macOS/Win | Toggle tag window (show project tags in the right window)                |
| `<leader>gs`      | Normal        | Linux/macOS/Win | Show Git status result                                                   |
| `<leader>gw`      | Normal        | Linux/macOS/Win | Run Git add for current file                                             |
| `<leader>gc`      | Normal        | Linux/macOS/Win | Run git commit                                                           |
| `<leader>gpl`     | Normal        | Linux/macOS/Win | Run git pull                                                             |
| `<leader>gpu`     | Normal        | Linux/macOS/Win | Run git push                                                             |
| `<leader>gbd`     | Normal        | Linux/macOS/Win | Delete a branch                                                          |
| `<leader>gbn`     | Normal        | Linux/macOS/Win | Create a new branch                                                      |
| `<leader>gl`      | Normal/Visual | Linux/macOS/Win | Get perm link for current/visually-select lines                          |
| `<leader>gbr`     | Normal        | macOS           | Browse current git repo in browser                                       |
| `<leader>gb`      | Visual        | macOS           | Blame current line                                                       |
| `<F9>`            | Normal        | Linux/macOS/Win | Compile&run current source file (for C++, LaTeX, Lua, Python)            |
| `<F11>`           | Normal        | Linux/macOS/Win | Toggle spell checking                                                    |
| `<F12>`           | Normal        | Linux/macOS/Win | Toggle paste mode                                                        |
| `\x`              | Normal        | Linux/macOS/Win | Close location or quickfix window                                        |
| `\d`              | Normal        | Linux/macOS/Win | Close current buffer and go to previous buffer                           |
| `{count}gb`       | Normal        | Linux/macOS/Win | Go to buffer `{count}` or next buffer in the buffer list.                |
| `{operator}iB`    | Normal        | Linux/macOS/Win | Operate in the whole buffer, `{operator}` can be `v`, `y`, `c`, `d` etc. |
| `Alt-k`           | Normal        | Linux/macOS/Win | Move current line or selected lines up                                   |
| `Alt-j`           | Normal        | Linux/macOS/Win | Move current line or selected lines down                                 |
| `Alt-m`           | Normal        | macOS/Win       | Markdown previewing in system browser                                    |
| `Alt-Shift-m`     | Normal        | macOS/Win       | Stopping Markdown previewing in system browser                           |
| `ctrl-u`          | Insert        | Linux/macOS/Win | Turn word under cursor to upper case                                     |
| `ctrl-t`          | Insert        | Linux/macOS/Win | Turn word under cursor to title case                                     |
| `jk`              | Insert        | Linux/macOS/Win | Return to Normal mode without lagging                                    |

  --------------------------------------------- **Customized Keys**---------------------------------------------------------------

| Shortcut          | Mode          | platform        | Description                                                              |
|-------------------|---------------|-----------------|--------------------------------------------------------------------------|
| `<space>e`        | Normal        | Linux/macOS/Win | Toggles NeoTree                                                          |
| `<space>o`        | Normal        | Linux/macOS/Win | NeoTree focus                                                            |
| `<space>i`        | Normal        | Linux/macOS/Win | Toggle Cursor from NeoTree to Buffer                                     |
| `<space>bd`       | Normal        | Linux/macOS/Win | Deletes Current Buffer without deleting the window                       | 
| `<space>bf`       | Normal        | Linux/macOS/Win | Formats Buffer                                                           |
| `<space>bs`       | Normal        | Linux/macOS/Win | Goes to NextBuffer                                                       |
| `<space>bp`       | Normal        | Linux/macOS/Win | Goes to PrevBuffer                                                       |
| `<space>ff`       | Normal        | Linux/macOS/Win | Opens Telescope to search files                                          |
| `<space>fg`       | Normal        | Linux/macOS/Win | Opens Telescope to grep files                                            |
| `<space>tt`       | Normal        | Linux/macOS/Win | Opens New Zsh Terminal Floating Window                                   |
| `<space>tk`       | Normal        | Linux/macOS/Win | Exits from the Terminal Window                                           |
| `<space>rw`       | Normal        | Linux/macOS/Win | Replace all Uses With Command                                            |
| `<space>gd`       | Normal        | Linux/macOS/Win | Goes Into The Implementation of Current Variable or Function             |
| `<space>j`        | Normal        | Linux/macOS/Win | Moves the cursor down by 10 spaces                                       |
| `<space>k`        | Normal        | Linux/macOS/Win | Moves the cursor up by 10 spaces                                         |
| `<space>l`        | Normal        | Linux/macOS/Win | Moves the cursor right by 10 spaces                                      |
| `<space>h`        | Normal        | Linux/macOS/Win | Moves the cursor left by 10 spaces                                       |

# Custom commands

In addition to commands provided by various plugins, I have also created some custom commands for personal use.

| command      | description                                                             | example                        |
|--------------|-------------------------------------------------------------------------|--------------------------------|
| `Redir`      | capture command output to a tabpage for easier inspection.              | `Redir hi`                     |
| `Edit`       | edit multiple files at the same time, supports globing                  | `Edit *.vim`                   |
| `Datetime`   | print current date and time or convert Unix time stamp to date and time | `Datetime 12345` or `Datetime` |
| `JSONFormat` | format a JSON file                                                      | `JSONFormat`                   |
| `CopyPath`   | copy current file path to clipboard                                     | `CopyPath relative`            |

# Contributing

If you find anything that needs improving, do not hesitate to point it out or create a PR.

If you come across an issue, you can first use `:checkhealth` command provided by `nvim` to trouble-shoot yourself.
Please read carefully the messages provided by health check.


# Further readings

Some of the resources that I find helpful in mastering Nvim is documented [here](docs/nvim_resources.md).
You may also be interested in my posts on configuring Nvim:
