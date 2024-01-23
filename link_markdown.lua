local M = {}
local telescope = require('telescope.builtin')
local action_state = require('telescope.actions.state')

function M.search_insert_link()
  local opts = {}
  -- Define the base path as configurable
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

