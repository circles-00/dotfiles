local status, prettier = pcall(require, "prettier")
if (not status) then
  return
end

prettier.setup {
  bin = "prettierd",
  filetypes = {
    "javascript",
    "typescript",
    "css",
    "javascriptreact",
    "typescriptreact",
    "json",
    "scss",
    "html",
    "vue",
    "svelte",
    "yaml",
    "markdown",
    "graphql",
    "less",
  }
}
