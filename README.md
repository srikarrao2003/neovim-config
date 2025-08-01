# Neovim Config

A modern, modular, and fast Neovim configuration for an efficient and enjoyable
coding experience.

## Features

- 🚀 **Fast startup** with lazy-loading plugins
- 🧠 **LSP** support for intelligent code completion, diagnostics, and more
- 🌈 **Treesitter**-powered syntax highlighting and code navigation
- 🛠️ **Custom keymaps** for productivity
- 🖌️ **Beautiful UI** with icons and themes
- 📝 **Language-specific settings** via `ftplugin` and `ftdetect`
- 🔌 **Easy plugin management** with [lazy.nvim](https://github.com/folke/lazy.nvim)

## Installation

1. **Backup your current config** (optional):

```sh
   mv ~/.config/nvim ~/.config/nvim.backup
```

1. **Clone this repo:**

```sh
   git clone https://github.com/yourusername/neovim-config.git ~/.config/nvim
```

1. **Start Neovim** and plugins will install automatically:

```sh
   nvim
```

## Directory Structure

- `after/`         – Post-load customizations
- `ftdetect/`      – Filetype detection scripts
- `ftplugin/`      – Filetype-specific settings
- `indent/`        – Indentation rules
- `lua/`           – Main Lua configuration
- `syntax/`        – Syntax files
- `templates/`     – Snippet/templates
- `init.lua`       – Entry point
- `lazy-lock.json` – Plugin lockfile

## Contributing

Pull requests and suggestions are welcome! Please open an issue or PR.
