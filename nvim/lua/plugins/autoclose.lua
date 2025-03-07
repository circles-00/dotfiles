return {
  "m4xshen/autoclose.nvim",
  enabled = false,
  config = function ()
    require("autoclose").setup({
      ['"'] = { escape = false, close = false, pair = '""' },
      ["'"] = { escape = false, close = false, pair = "''" },
      ["`"] = { escape = false, close = false, pair = "``" },
    })
  end
}
