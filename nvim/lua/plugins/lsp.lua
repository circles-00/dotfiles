return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
  config = function()
    local lspconfig = require("lspconfig")

    require("mason").setup()

    local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local lsp_format_on_save = function(bufnr)
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end

    local set_default_keymaps = function(bufnr)
      local opts = { buffer = bufnr, silent = true }
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
      vim.keymap.set({'n', 'x'}, '<F3>', function() vim.lsp.buf.format({async = true}) end, opts)
      vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
    end

    local on_attach = function(_, bufnr)
      set_default_keymaps(bufnr)
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local servers = {
      vtsls = {
        capabilities = capabilities,
        filetypes = {
          "javascript", "javascriptreact", "javascript.jsx",
          "typescript", "typescriptreact", "typescript.tsx",
        },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
        on_attach = function(client, bufnr)
          lsp_format_on_save(bufnr)
          on_attach(client, bufnr)
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set('n', '<leader>cV', function()
            client.request("workspace/executeCommand", {
              command = "typescript.selectTypeScriptVersion"
            })
          end, opts)
        end,
      },

      eslint = {},

      gopls = {
        capabilities = capabilities,
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            gofumpt = true,
            staticcheck = true,
            analyses = { unusedparams = true },
          },
        },
        on_attach = function(_, bufnr)
          set_default_keymaps(bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            group = augroup,
            callback = function()
              local params = vim.lsp.util.make_range_params()
              params.context = { only = { "source.organizeImports" } }
              local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
              for cid, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                  if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                  end
                end
              end
              vim.lsp.buf.format({ async = false })
            end,
          })
        end,
      },

      omnisharp = {
        cmd = { "/usr/bin/dotnet", vim.fn.expand("~/Downloads/omnisharp-linux-x64-net6.0/OmniSharp.dll") },
        enable_import_completion = true,
        organize_imports_on_format = true,
        capabilities = capabilities,
        on_attach = on_attach,
      },

      lua_ls = {
        capabilities = capabilities,
        on_attach = on_attach,
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then return end
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
          })
        end,
        settings = { Lua = {} },
      },
    }

    for server, config in pairs(servers) do
      lspconfig[server].setup(config)
    end

    local simple_servers = { "rust_analyzer", "tailwindcss", "pyright", "clangd", "html", "clojure_lsp", "terraformls" }
    for _, server in ipairs(simple_servers) do
      lspconfig[server].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end

    vim.diagnostic.config({ virtual_text = false })
  end,
}
