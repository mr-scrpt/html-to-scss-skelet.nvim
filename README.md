# html-to-scss-skelet.nvim

A plugin for Neovim that generates an SCSS skeleton based on allocated HTML code.

## How it works

Converts your HTML to SCSS, taking into account the BEM class naming methodology

### This

```
<div class="action">
  <div class="action__inner">
    <button
      class="action__btn button button_view_action button_size_xl popup-trigger"
    >
      <span class="button__text">Go to license</span>
    </button>
    <a
      href="#"
      class="action__btn button button_view_ghost button_size_xl"
    >
      <span class="button__text">Go to registry</span>
    </a>
  </div>
</div>

```

### To this

```
.action {
  &__inner {
  }
  &__btn {
  }
}

.button {
  &_view_action {
  }
  &_size_xl {
  }
  &_view_ghost {
  }
  &__text {
  }
}

.popup-trigger {
}
```

## Installation

Use [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    'mr-scrpt/html-to-scss-skelet.nvim',
    config = function()
        vim.api.nvim_set_keymap(
			"v",
			"<leader>ms",
			":lua require('html_to_scss_skelet').html_to_scss()<CR>",
			{ noremap = true, silent = true }
	)

    end
}

```
