package.path = package.path .. ';' .. vim.fn.stdpath('config') .. '/?.lua'

-- Plug installation
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
vim.cmd 'packadd packer.nvim'

-- Load Packer
require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Plugins
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'}, {'BurntSushi/ripgrep'} }
    }
    use 'folke/which-key.nvim'
	
    use 'neovim/nvim-lspconfig'
	use {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets"
	}
	use 'cdelledonne/vim-cmake'
    use 'morhetz/gruvbox'

end)

local keymap = require('keymap')
keymap.setup()

-- Set line numbering
vim.opt.number = true

-- Set indent settings
vim.o.shiftwidth = 2  -- Set the number of spaces for each indentation level
vim.o.softtabstop = 2 -- Set the number of spaces that a <Tab> counts for while editing
vim.o.expandtab = true -- Use spaces instead of tabs for indentation

vim.opt.langmenu = "de_DE"
vim.env.LANG = 'de_DE.UTF-8'

-- Telescope configuration
require('telescope').setup{}

-- Which-key configuration
require("which-key").setup{}

-- LSP-config
require('mason').setup({
    cmp = true,
})
require("mason-lspconfig").setup()
require("plugin.lsp").setup{}

-- Color theme
vim.cmd('colorscheme gruvbox')
