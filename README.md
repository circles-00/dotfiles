# Dotfiles
Like it or not, dotfiles are a part of every linux user's life. They are the files that define the look and feel of your system, and are often the first thing you change when you get a new system.
My dotfiles for my linux setup, including i3, polybar, nvim, tmux, zsh, and alacritty.

Like most dotfiles, these are a work in progress and are constantly changing.

# Ensure installed
- i3
- polybar
- nvim
- tmux
- alacritty
- zsh
- oh-my-zsh
- picom
- feh
- flameshot
- redshift
- playerctl
- lsp-language-server
- go

Probably missing something above, but that's the gist of it.

# Scripts
- `typescript-barrel-generator` - Generates a barrel file for typescript files in a directory

This goes to `~/.local/scripts/typescript-barrel-generator.js`

- `tmux-sessionizer` - Generates a tmux session with a window for each file in a directory

This goes to `~/.local/bin/tmux-sessionizer `

# Eslint
Since configuring eslint is always a pain in the ass, this will save your life: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint

Ensure above is installed and set up.
Or more neat:

```shell
npm i -g vscode-langservers-extracted
```
