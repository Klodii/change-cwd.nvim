local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local actions = require "telescope.actions"
local action_state = require('telescope.actions.state')

--- Splits a string into a table based on a delimiter
---@param input_string string example: 'a,b,c'
---@param delimiter string example: ','
---@return table example: {'a', 'b', 'c'}
local split_string = function(input_string, delimiter)
  delimiter = delimiter or '%s'
  local splitted_string = {}
  local i = 1
  for str in string.gmatch(input_string, '([^' .. delimiter .. ']+)') do
    splitted_string[i] = str
    i = i + 1
  end
  return splitted_string
end

local M = {}

local options = {
  root_dir = '~/',
}

M.setup = function(opts)
  opts = opts or {}
  opts.root_dir = opts.root_dir or '~/'
  options = opts
end

--- Telescope picker, used to select the new working directory
--- @param directories string[] the list of directories
--- @param callback function Since the picker is asynchronous and you can't
---                           directly return from the picker in a synchronous
---                           function, a common approach is to use a callback
---                           or store the selected item in a global variable.
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
  }, {}):find()
end

--- Change the working directory
--- @param dir_path string path of the new working directory
local _change_working_directory = function(dir_path)
  vim.api.nvim_command('cd ' .. dir_path) -- change working directory
  vim.api.nvim_command('e ' .. dir_path)  -- move to Explorer
  vim.notify("Changed working directory to: " .. dir_path, vim.log.levels.INFO)
end

--- Select the new working directory
M.change_working_directory = function()
  local dir_options = vim.fn.system("ls -d " .. options.root_dir .. "*/")
  -- vim.v.shell_error: The exit status of the last shell command run with vim.fn.system().
  -- If the exit code is non-zero, it indicates an error
  if vim.v.shell_error ~= 0 then
    vim.notify("Command failed with error: " .. dir_options, vim.log.levels.ERROR)
    return
  end

  local dir_options_table = split_string(dir_options, '\n')
  select_directory(dir_options_table, _change_working_directory)
end

return M
