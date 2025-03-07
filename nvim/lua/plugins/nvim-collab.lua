return {
  enabled = false,
  '~/CodingProjects/personal/nvim-collab',
  dev = true,
  config = function ()
    require("nvim-collab").setup()
  end
}
