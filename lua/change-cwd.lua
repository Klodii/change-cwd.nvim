local M = {}

--- Select the new working directory
M.change_working_directory = function()
  local cwd = vim.fn.getcwd()
  local buf = vim.api.nvim_create_buf(false, true)       -- Create a new empty buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { cwd }) -- Set the message in the buffer

  -- Open floating window
  local current_height = vim.api.nvim_get_option_value('lines', {})
  local current_width = vim.api.nvim_get_option_value('columns', {})
  local float_opts = {
    relative = 'editor', -- The floating window is relative to the editor
    width = #cwd,
    height = 1,
    row = math.floor(current_height * 0.4), -- Window appears near the middle of the screen
    col = math.floor((current_width - #cwd) * 0.5),
    style = 'minimal',                      -- Minimal window style with no borders or other decorations
    border = 'rounded',                     -- Optional: Adds rounded borders
  }

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, float_opts) -- Open the window with the buffer content

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>q<CR>', {})
end

return M
