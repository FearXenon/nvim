local M = {}

M.setup = function()
    
    local myvimdir = vim.fn.fnamemodify(vim.fn.getenv("MYVIMRC"), ":h")

    -- map leader to <Space>
    vim.g.mapleader = " "
  
    -- Key mappings
    vim.api.nvim_set_keymap('i', 'jk', '<Esc>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap(  't'  ,  '<Leader><ESC>'  ,  '<C-\\><C-n>'  ,  {noremap = true}  )
    vim.api.nvim_set_keymap('n', '<leader>sv', ':luafile $MYVIMRC<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>sc', ':cd '..myvimdir..'<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-z>', ':u<CR>', { noremap = true })
    vim.api.nvim_set_keymap('n', '<C-y>', ':redo<CR>', { noremap = true })

    vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true })   
    
    local wk = require('which-key')
    local builtin = require('telescope.builtin')

    vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', { noremap = true, silent = true })

    wk.register({
      ["<leader>f"] = {
            name = "Telescope",
            f = { builtin.find_files, "Find Files" },
            g = { builtin.live_grep, "Live Grep" },
            b = { builtin.buffers, "Buffers" },
            h = { builtin.help_tags, "Help Tags" }
      },
	  ["<leader>s"] = {
			name = "Config/Nvim editing"
	  }
    })	
end

return M
