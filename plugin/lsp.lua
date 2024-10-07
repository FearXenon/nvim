local M = {}

M.setup = function()

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

	local lspconfig = require('lspconfig')

	-- Define a function to set up keybindings for each language server
	local function setup_lsp_keybindings(client, bufnr)
		local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

		-- Enable keybindings for LSP actions
		buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
		buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })

		-- Set up additional capabilities if needed
		if client.resolved_capabilities.document_formatting then
			buf_set_option('formatexpr', 'vim.lsp.buf.formatting()')
		end
	end

	-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
	local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
	for _, lsp in ipairs(servers) do
		lspconfig[lsp].setup {
			root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
			capabilities = capabilities,
			on_attach = setup_lsp_keybindings
		}
	end

	-- CMP
	vim.opt.completeopt = {'menu', 'menuone', 'noselect'}


	local cmp = require('cmp')
	local luasnip = require('luasnip')

	local select_opts = {behavior = cmp.SelectBehavior.Select}

	cmp.setup({
	  snippet = {
		expand = function(args)
		  luasnip.lsp_expand(args.body)
		end
	  },
	  sources = {
		{name = 'path'},
		{name = 'nvim_lsp', keyword_length = 1},
		{name = 'buffer', keyword_length = 3},
		{name = 'luasnip', keyword_length = 2},
	  },
	  window = {
		documentation = cmp.config.window.bordered()
	  },
	  formatting = {
		fields = {'menu', 'abbr', 'kind'},
		format = function(entry, item)
		  local menu_icon = {
			nvim_lsp = 'λ',
			luasnip = '⋗',
			buffer = 'Ω',
			path = '🖫',
		  }

		  item.menu = menu_icon[entry.source.name]
		  return item
		end,
	  },
	  mapping = {
		['<Up>'] = cmp.mapping.select_prev_item(select_opts),
		['<Down>'] = cmp.mapping.select_next_item(select_opts),

		['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
		['<C-n>'] = cmp.mapping.select_next_item(select_opts),

		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),

		['<C-e>'] = cmp.mapping.abort(),
		['<C-y>'] = cmp.mapping.confirm({select = true}),
		['<CR>'] = cmp.mapping.confirm({select = false}),

		['<C-f>'] = cmp.mapping(function(fallback)
		  if luasnip.jumpable(1) then
			luasnip.jump(1)
		  else
			fallback()
		  end
		end, {'i', 's'}),

		['<C-b>'] = cmp.mapping(function(fallback)
		  if luasnip.jumpable(-1) then
			luasnip.jump(-1)
		  else
			fallback()
		  end
		end, {'i', 's'}),

		['<Tab>'] = cmp.mapping(function(fallback)
		  local col = vim.fn.col('.') - 1

		  if cmp.visible() then
			cmp.select_next_item(select_opts)
		  elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
			fallback()
		  else
			cmp.complete({ mode = 'search' })
		  end
		end, {'i', 's'}),

		['<S-Tab>'] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			cmp.select_prev_item(select_opts)
		  else
			fallback()
		  end
		end, {'i', 's'}),
	  },
	})	
end


return M