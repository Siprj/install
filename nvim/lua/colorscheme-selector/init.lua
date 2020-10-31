local finders = require('telescope.finders')
local actions = require('telescope.actions')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local conf = require('telescope.config').values

local function helloWorld()
  local opts = {}
  opts.entry_maker = make_entry.gen_from_string(opts)

  local color_schemes = vim.fn.getcompletion("", "color")

  local original_set_selection = pickers._Picker.set_selection

  pickers._Picker.set_selection = function (self, row)
    local v = original_set_selection(self, row)

    local row = self:get_selection_row()
    if not self:can_select_row(row) then
      log.debug("Cannot select colorscheme")
      return
    end

    local entry = self.manager:get_entry(self:get_index(row))
    vim.cmd("colorscheme " .. entry.value)
  end

  pickers.new(opts, {
    prompt = 'Color schemes',
    finder = finders.new_table(color_schemes),
    sorter = sorters.get_fuzzy_file(),
--    sorter = conf.generic_sorter(),
    layout_strategy = "vertical",
    width = 0.2,
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', actions.close)
      map('n', '<CR>', actions.close)
      return true
    end,
  }):find()
end

return {
    helloWorld = helloWorld
}
