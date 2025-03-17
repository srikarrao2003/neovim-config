
-- LSP
local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic
local lspconfig = require("lspconfig")

local utils = require("utils")

-- set quickfix list from diagnostics in a certain buffer, not the whole workspace
local set_qflist = function(buf_num, severity)
  local diagnostics = nil
  diagnostics = diagnostic.get(buf_num, { severity = severity })

  local qf_items = diagnostic.toqflist(diagnostics)
  vim.fn.setqflist({}, " ", { title = "Diagnostics", items = qf_items })

  -- open quickfix by default
  vim.cmd([[copen]])
end

local custom_attach = function(client, bufnr)
  -- Mappings.
  local map = function(mode, l, r, opts)
    opts = opts or {}
    opts.silent = true
    opts.buffer = bufnr
    keymap.set(mode, l, r, opts)
  end

  -- Set some key bindings conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider and client.name ~= "lua_ls" then
    map({ "n", "x" }, "<space>f", vim.lsp.buf.format, { desc = "format code" })
  end

  -- Uncomment code below to enable inlay hint from language server, some LSP server supports inlay hint,
  -- but disable this feature by default, so you may need to enable inlay hint in the LSP server config.
  -- vim.lsp.inlay_hint.enable(true, {buffer=bufnr})

  api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always", -- show source in diagnostic popup window
        prefix = " ",
      }

      if not vim.b.diagnostics_pos then
        vim.b.diagnostics_pos = { nil, nil }
      end

      local cursor_pos = api.nvim_win_get_cursor(0)
      if
        (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
        and #diagnostic.get() > 0
      then
        diagnostic.open_float(nil, float_opts)
      end

      vim.b.diagnostics_pos = cursor_pos
    end,
  })

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]])

    local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    api.nvim_create_autocmd("CursorHold", {
      group = gid,
      buffer = bufnr,
      callback = function()
        lsp.buf.document_highlight()
      end,
    })

    api.nvim_create_autocmd("CursorMoved", {
      group = gid,
      buffer = bufnr,
      callback = function()
        lsp.buf.clear_references()
      end,
    })
  end

  if vim.g.logging_level == "debug" then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
  end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- required by nvim-ufo
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- For what diagnostic is enabled in which type checking mode, check doc:
-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#diagnostic-settings-defaults
-- Currently, the pyright also has some issues displaying hover documentation:
-- https://www.reddit.com/r/neovim/comments/1gdv1rc/what_is_causeing_the_lsp_hover_docs_to_looks_like/

if utils.executable("pyright") then
  local new_capability = {
    -- this will remove some of the diagnostics that duplicates those from ruff, idea taken and adapted from
    -- here: https://github.com/astral-sh/ruff-lsp/issues/384#issuecomment-1989619482
    textDocument = {
      publishDiagnostics = {
        tagSupport = {
          valueSet = { 2 },
        },
      },
      hover = {
        contentFormat = { "plaintext" },
        dynamicRegistration = true,
      },
    },
  }
  local merged_capability = vim.tbl_deep_extend("force", capabilities, new_capability)

  -- lspconfig.pyright.setup {
  --   cmd = { "delance-langserver", "--stdio" },
  --   on_attach = custom_attach,
  --   capabilities = merged_capability,
  --   settings = {
  --     pyright = {
  --       -- disable import sorting and use Ruff for this
  --       disableOrganizeImports = true,
  --       disableTaggedHints = false,
  --     },
  --     python = {
  --       analysis = {
  --         autoSearchPaths = true,
  --         diagnosticMode = "workspace",
  --         typeCheckingMode = "standard",
  --         useLibraryCodeForTypes = true,
  --         -- we can this setting below to redefine some diagnostics
  --         diagnosticSeverityOverrides = {
  --           deprecateTypingAliases = false,
  --         },
  --         -- inlay hint settings are provided by pylance?
  --         inlayHints = {
  --           callArgumentNames = "partial",
  --           functionReturnTypes = true,
  --           pytestParameters = true,
  --           variableTypes = true,
  --         },
  --       },
  --     },
    -- },
  -- }

  lspconfig.pyright.setup{
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",  -- Can be "off", "basic", or "strict"
                -- Customize these based on your needs
                diagnosticSeverityOverrides = {
                    reportGeneralTypeIssues = "warning",
                    reportOptionalMemberAccess = "information",
                    reportOptionalSubscript = "warning",
                    reportPrivateImportUsage = "information",
                },
            }
        }
    },
    capabilities = merged_capability,
    on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        
        -- Optional: format on save
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     buffer = bufnr,
        --     callback = function() vim.lsp.buf.format { async = false } end
        -- })
    end,
  }
else
  vim.notify("pyright not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

if utils.executable("ruff") then
  require("lspconfig").ruff.setup {
    on_attach = custom_attach,
    capabilities = M.capabilities,
    init_options = {
      -- the settings can be found here: https://docs.astral.sh/ruff/editors/settings/
      settings = {
        organizeImports = true,
      },
    },
  }
end

-- Disable ruff hover feature in favor of Pyright
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- vim.print(client.name, client.server_capabilities)

    if client == nil then
      return
    end
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from Ruff",
})

if utils.executable("ltex-ls") then
  lspconfig.ltex.setup {
    on_attach = custom_attach,
    cmd = { "ltex-ls" },
    filetypes = { "text", "plaintex", "tex", "markdown" },
    settings = {
      ltex = {
        language = "en",
      },
    },
    flags = { debounce_text_changes = 300 },
  }
end

if utils.executable("clangd") then
  lspconfig.clangd.setup{
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--all-scopes-completion", -- Important for preprocessor blocks
      "--pch-storage=memory",    -- Better handling of headers
      "--offset-encoding=utf-16",
    },
    init_options = {
      compilationDatabasePath = "build",
    },
    filetypes = { "c", "cpp", "objc", "objcpp","h","hpp"},
    root_dir = lspconfig.util.root_pattern(
      'compile_commands.json',
      'compile_flags.txt',
      '.git'
    ),
    opts = {
    on_attach = custom_attach,
    capabilities = capabilities,
    },
  }
end

-- Cmake Setup
if utils.executable("cmake-language-server") then
  lspconfig.cmake.setup({
    cmd = { "cmake-language-server" },
    filetypes = { "cmake", "txt" },
    init_options = {
      buildDirectory = "build"
    },
  })
end

local configs = require('lspconfig.configs')
local util = require('lspconfig.util')

if not configs.mlir then
  configs.mlir = {
    default_config = {
      cmd = { 'mlir-lsp-server' },
      filetypes = { 'mlir' },
      root_dir = util.root_pattern('.git', 'llvm-project'),
      settings = {},
    },
  }
end

-- TableGen LSP configuration
if not configs.tablegen then
  configs.tablegen = {
    default_config = {
      cmd = { 'tblgen-lsp-server' },
      filetypes = { 'tablegen', 'td' },
      root_dir = util.root_pattern('.git', 'llvm-project'),
      settings = {},
    },
  }
end

-- MLIR LSP configuration
if utils.executable("mlir-lsp-server") then
  -- Setup all LSP servers
  lspconfig.mlir.setup({
    capabilities = capabilities,
    on_attach = custom_attach,
  })
end

-- TableGen LSP configuration
if utils.executable("tblgen-lsp-server") then
  -- Setup all LSP servers
  lspconfig.tablegen.setup({
    capabilities = capabilities,
    on_attach = custom_attach,
    cmd = {
      "tblgen-lsp-server",
      "--tablegen-compilation-database=build/tablegen_compile_commands.yml",
    },
    -- patterns extended from clangd
    root_dir = util.root_pattern(
      "tablegen_compile_commands.yml",
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      "compile_commands.json",
      "compile_flags.txt",
      "configure.ac",
      ".git"
    ),
  })
end

-- set up vim-language-server
if utils.executable("vim-language-server") then
  lspconfig.vimls.setup {
    on_attach = custom_attach,
    flags = {
      debounce_text_changes = 500,
    },
    capabilities = capabilities,
  }
else
  vim.notify("vim-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- set up bash-language-server
if utils.executable("bash-language-server") then
  lspconfig.bashls.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
  }
end

-- settings for lua-language-server can be found on https://luals.github.io/wiki/settings/
if utils.executable("lua-language-server") then
  lspconfig.lua_ls.setup {
    on_attach = custom_attach,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        hint = {
          enable = true,
        },
      },
    },
    capabilities = capabilities,
  }
end

-- Change diagnostic signs.
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#FF0000", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#FFA500", bg = "NONE" }) -- Orange foreground
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#00BFFF", bg = "NONE" }) -- Light blue foreground
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#10B981", bg = "NONE" }) -- Green foreground

-- global config for diagnostic
diagnostic.config {
  underline = false,
  virtual_text = false,
  signs = true,
  severity_sort = true,
}

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = false,
--   signs = true,
--   update_in_insert = false,
-- })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})