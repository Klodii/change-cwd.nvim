# change-cwd

Change the working directory to another one by selecting from a Tlescope picker.
By default, only the directory that are in the `$HOME` directory can be
selected, but it can be overwritten in the `setup`.


## Installation

### Lazy example

```lua
return {
  {
    "Klodii/change-cwd.nvim",
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      require "change-cwd".setup({ root_dir = '~/work/forest/' }) -- by default it is '~'
      vim.keymap.set("n", "<leader>ff", "<cmd>:lua require('change-cwd').change_working_directory()<cr>",
        { desc = 'change current working directory' })
    end
  }
}

```
