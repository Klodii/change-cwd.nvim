local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local actions = require "telescope.actions"
local action_state = require('telescope.actions.state')

local M = {}

local options = {
  root_dir = '~',
  explorer = 'Oil'
}

M.setup = function(opts)
  opts = opts or {}
  opts.root_dir = opts.root_dir or '~'
  -- opts.explorer = opts.explorer or 'Explorer'
  opts.explorer = opts.explorer or 'Explorer'
  options = opts
end


-- Telescope picker, used to select the new working directory
-- @param directories: string[] the list of directories
-- @param callback: function Since the picker is asynchronous and you can't
--                           directly return from the picker in a synchronous
--                           function, a common approach is to use a callback
--                           or store the selected item in a global variable.
local select_directory = function(directories, callback)
  pickers.new({
    prompt_title = "Choose a directory",
    finder = finders.new_table({
      results = directories,
    }),
    sorter = sorters.get_generic_fuzzy_sorter(),
    previewer = false,
    attach_mappings = function(prompt_bufnr, map)
      -- action to do when selecting an option
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection then
          callback(selection[1])
        end
        actions.close(prompt_bufnr) -- Close the picker
      end)
      return true
    end,
  }):find()
end

--- Change the working directory
--- @param dir: string new working directory
local change_working_directory = function(selected_item)
  vim.api.nvim_command('cd ' .. selected_item)
  vim.api.nvim_command(options.explorer)
  vim.notify("Changed working directory to: " .. selected_item, vim.log.levels.INFO)
end

--- Select the new working directory
M.ask_new_directory = function()
  local dir_options = vim.fn.system("ls -l")
  -- vim.v.shell_error: The exit status of the last shell command run with vim.fn.system().
  -- If the exit code is non-zero, it indicates an error
  if vim.v.shell_error ~= 0 then
    vim.notify("Command failed with error: " .. dir_options, vim.log.levels.ERROR)
    return
  end

  select_directory({ '~/.config/nvim', '~/playground/nvim-plugins/change-cwd.nvim' }, change_working_directory)
end


-- run locally for testing
-- M.ask_new_directory()
return M
