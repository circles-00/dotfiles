local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup{
  settings = {
    Lua = {
      diagnostics = {
        -- Fix Undefined global 'vim'
        globals = { 'vim' }
      }
    }
  }
}

