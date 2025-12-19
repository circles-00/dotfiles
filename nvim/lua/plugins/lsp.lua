return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()

    -- Use vim.diagnostic.config for signs (replaces vim.fn.sign_define)
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "E",
          [vim.diagnostic.severity.WARN] = "W",
          [vim.diagnostic.severity.HINT] = "H",
          [vim.diagnostic.severity.INFO] = "I",
        },
      },
      virtual_text = false,
    })

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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
      vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
      vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
    end

    local on_attach = function(_, bufnr)
      set_default_keymaps(bufnr)
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local servers = {
      tsgo = {
        on_attach = function(_, bufnr)
          on_attach(_, bufnr)
        end,
      },
      biome = {},
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

    -- Configure and enable servers
    for server, config in pairs(servers) do
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end

    local simple_servers = { "pyright", "html" }
    for _, server in ipairs(simple_servers) do
      vim.lsp.config(server, {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable(server)
    end
  end,
}
