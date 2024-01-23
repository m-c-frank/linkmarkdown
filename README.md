prompt: i need a way to easily link to other markdown files without knowing the exact filepath or title. imagine i am running on a linux machine and want the most minimal approach. if necessary write the most minimal nvim plugin. so when i type leader lm in normal mode it should trigger the file search and update the list of proposed results with each typed character. i want my typed text to be the displayed text and the path to the file the actual link. i think we can do it like obsidian with the | character. what do you thing okay use telescope instead and just take the text that the user has input as the plain text of the link and the selected path as the actual link
something like that but also define the base path as a configurable and give it to me as a readme with the directory tree of a nvim plugin that is hosted at github.com/m-c-frank/linkmarkdown. do it directly in my nvim/lua/custom/plugins directory of my .config and with kickstart fork

result:
# LinkMarkdown Plugin for Neovim

This plugin allows you to easily insert Markdown links to other files without knowing the exact filepath or title, using Telescope to search and select files. It's designed for Neovim users who want a minimal and efficient way to create links in their Markdown documents.

## Features

- Search files within a specified base path using Telescope.
- Insert Markdown links with the typed text as the link text and the selected file path as the link.
- Customizable base path for file searches.

## Prerequisites

- Neovim (0.5 or newer)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)

## Installation

First, ensure you have Telescope installed. Then, you can add this plugin to your Neovim setup. If you're using `packer.nvim` for managing plugins, add the following to your plugin list:

```lua
use {
  'm-c-frank/linkmarkdown',
  requires = {'nvim-telescope/telescope.nvim'},
  config = function()
    require('custom.plugins.linkmarkdown').setup()
  end
}
```

Replace `'m-c-frank/linkmarkdown'` with the path to the local clone of this plugin if it's not hosted on a public repository.

## Plugin Setup

After installing the plugin, you need to configure it in your `init.lua`. Here's how to set the base path and key mappings:

```lua
-- Set the base path for file searches (change "/your/base/path" to your desired path)
vim.g.linkmarkdown_base_path = "/your/base/path"

-- Key mapping for triggering the search and link insertion
vim.api.nvim_set_keymap('n', '<leader>lm', ':lua require("custom.plugins.linkmarkdown").search_insert_link()<CR>', {noremap = true, silent = true})
```

## Plugin Source Code

Below is the entire source code for the plugin. You can place this in a file named `link_markdown.lua` inside your Neovim configuration directory (e.g., `.config/nvim/lua/custom/plugins/linkmarkdown/`).

```lua
local M = {}
local telescope = require('telescope.builtin')
local action_state = require('telescope.actions.state')

function M.search_insert_link()
  local opts = {}
  opts.cwd = vim.g.linkmarkdown_base_path or vim.loop.cwd()

  telescope.find_files({
    prompt_title = "Insert Markdown Link",
    cwd = opts.cwd,
    attach_mappings = function(prompt_bufnr, map)
      local insert_link = function()
        local selection = action_state.get_selected_entry()
        local link_text = action_state.get_current_line()
        local link_path = selection.path
        local markdown_link = string.format("[%s](%s)", link_text, link_path)
        vim.api.nvim_put({markdown_link}, '', true, true)
        vim.cmd('stopinsert')
      end

      map('i', '<CR>', insert_link)
      map('n', '<CR>', insert_link)
      return true
    end
  })
end

return M
```

## Usage

With the plugin installed and configured:

1. Navigate to where you want to insert a Markdown link in your document.
2. Press `<leader>lm` in Normal mode. This will open Telescope's file search within the base path you've set.
3. Start typing to filter the list of files. The list will update with each character you type.
4. Select the file you want to link to and press Enter. A Markdown link will be inserted at your cursor position, using the text you've typed as the link text and the file path as the link target.

## Customization

You can change the base path and the key mapping as needed by modifying the settings in your `init.lua`.

---

For further customization or issues, please refer to the plugin's documentation and the Telescope documentation.
