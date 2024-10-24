# html-to-scss-skelet.nvim

A plugin for Neovim that generates an SCSS skeleton based on allocated HTML code.

## Installation

Use [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    'mr-scrpt/html-to-scss-skelet.nvim',
    config = function()
        vim.api.nvim_set_keymap('v', '<Leader>s', '<Cmd>lua require("html_to_scss").generate_scss_skeleton()<CR>', { noremap = true, silent = true })
    end
}

```
