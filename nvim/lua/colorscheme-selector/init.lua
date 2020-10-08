local finders = require('telescope.finders')
local actions = require('telescope.actions')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local sorters = require('telescope.sorters')
local utils = require('telescope.utils')

local function helloWorld()
  print("*******************************")
  local opts = {}
  opts.entry_maker = make_entry.gen_from_string(opts)

  local color_schemes = vim.fn.getcompletion("", "color")

  local previewer = {
    preview = function(self, selected)
      vim.cmd("colorscheme " .. selected.value)
    end,
    teardown = function(self)
    end,
  }


  pickers.new(opts, {
    prompt    = 'Color schemes',
    finder    = finders.new_table(color_schemes),
    sorter    = sorters.get_fuzzy_file(),
    previewer = previewer,
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', actions.close)
      map('n', '<CR>', actions.close)
      return true
    end,
    preview_cutoff = 20
  }):find()
end

return {
    helloWorld = helloWorld
}
