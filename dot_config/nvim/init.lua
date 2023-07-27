vim.api.nvim_set_option("ignorecase", true)
vim.api.nvim_set_option("ignorecase", true)
vim.api.nvim_set_option("smartcase", true)
vim.api.nvim_set_option("number", true)
vim.api.nvim_set_option("scrolloff", 8)
vim.api.nvim_set_option("sidescrolloff", 8)
vim.api.nvim_set_option("incsearch", true)
vim.api.nvim_set_option("relativenumber", true)
vim.api.nvim_set_option("nu", true)
vim.api.nvim_set_option("hlsearch", false)
vim.api.nvim_set_option("errorbells", false)
vim.api.nvim_set_option("hidden", true)
vim.api.nvim_set_option("tabstop", 4)
vim.api.nvim_set_option("shiftwidth", 4)
vim.api.nvim_set_option("mouse", "a")
vim.api.nvim_set_option("wrap", false)

vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	--{ 'neoclide/coc.nvim',            branch = 'master',                  build = 'yarn install --frozen-lockfile' },
	--{ 'junegunn/fzf',      build = ':call fzf#install()' },
	--'junegunn/fzf.vim',
	'arkav/lualine-lsp-progress',
	'neovim/nvim-lspconfig',
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-nvim-lsp',
	{
		"L3MON4D3/LuaSnip",
		version = "2.*",
		build = "make install_jsregexp"
	},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'jose-elias-alvarez/null-ls.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	'mfussenegger/nvim-jdtls',
	'gruvbox-community/gruvbox',
	'tpope/vim-fugitive',
	'tpope/vim-surround',
	'airblade/vim-gitgutter',
	'preservim/nerdcommenter',
	-- Plug 'hsanson/vim-android'
	{ 'iamcco/markdown-preview.nvim', build = ':call mkdp#util#install()' },
	--'rust-lang/rust.vim',
	-- "Plug 'neovim/nvim-lspconfig'
	'tpope/vim-vinegar',
	-- "Plug 'simrat39/rust-tools.nvim'
	'mfussenegger/nvim-dap',
	--{ 'evanleck/vim-svelte', event = 'BufEnter *.svelte' },
	--'sheerun/vim-polyglot',
	--{ 'DingDean/wgsl.vim',   event = 'BufEnter *.wgsl' },
	--'tikhomirov/vim-glsl',
	-- Plug 'posva/vim-vue'
	-- Plug 'hashivim/vim-terraform'
	-- Plug 'leafgarland/typescript-vim'
	'lambdalisue/suda.vim',
	{ 'dinhhuy258/vim-database',      branch = 'master',                  build = ':UpdateRemotePlugins' },
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			'kyazdani42/nvim-web-devicons',
		}
	},
	-- " If you want to have icons in your statusline choose one of these
	'vinnymeller/swagger-preview.nvim',
	--'elkowar/yuck.vim',
	'wannesm/wmgraphviz.vim',
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
})

local null_ls = require'null-ls'
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,
    },
})

require 'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
	}
}

local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()
parser_config.gotmpl = {
	install_info = {
		url = "https://github.com/ngalaiko/tree-sitter-go-template",
		files = { "src/parser.c" }
	},
	filetype = "gotmpl",
	used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" }
}

local ls = require 'luasnip'
-- Set up LuaSnip
vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })


-- Set up nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			--vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		--{ name = 'vsnip' }, -- For vsnip users.
		{ name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
	})
})


-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')
lspconfig.pyright.setup {
	capabilities = capabilities
}
lspconfig.lua_ls.setup {
	capabilities = capabilities
}
lspconfig.tsserver.setup {
	capabilities = capabilities
}
lspconfig.rust_analyzer.setup {
	-- Server-specific settings. See `:help lspconfig-setup`
	settings = {
		['rust-analyzer'] = {},
	},
	capabilities = capabilities
}
lspconfig.cssls.setup {}
--lspconfig.java_language_server.setup {}
--lspconfig.jdtls.setup {}

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<A-F>', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})


vim.cmd "colorscheme gruvbox"

vim.g.coc_global_extensions = {
	'coc-snippets',
	'coc-pairs',
	'coc-json',
	'coc-prettier',
	'coc-clangd',
	'coc-java',
	'coc-tsserver',
	-- 'coc-rls',
	'coc-pyright',
	'coc-rust-analyzer',
	'coc-flutter',
	'coc-emmet',
	'coc-xml',
	'coc-sql',
	'coc-svelte',
	'@yaegassy/coc-tailwindcss3',
	'coc-eslint',
	'coc-lua'
}

-- let g:netrw_keepdir=0
vim.g.netrw_banner = 0
-- let g:netrw_keepj=""

-- lua require('rust-tools').setup({})

--  Use <c-space> to trigger completion.

--vim.keymap.set('i', '<c-space>', 'coc#refresh()', { expr = true, noremap = true, silent = true })


-- " Use tab for trigger completion with characters ahead and navigate.
-- " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
-- inoremap <silent><expr> <TAB>
--\ pumvisible() ? coc#pum#next(1) :
--\ <SID>check_back_space() ? "\<TAB>" :
--\ coc#refresh()

-- "let g:coc_snippet_next = '<TAB>'
-- "let g:coc_snippet_prev = '<S-TAB>'
-- inoremap <expr><S-TAB> pumvisible() ? coc#pum#prev(1) : "\<C-h>"


--function _G.check_back_space()
--local col = fn.col('.') - 1
--if col == 0 or fn.getline('.'):sub(col, col):match('%s') then
--return true
--else
--return false
--end
--end

--vim.keymap.set('v', '<C-j>', '<Plug>(coc-snippets-select)')

--vim.keymap.set('n', '<A-F>', '<Plug>(coc-format)', { silent = true })

--vim.keymap.set('i', '<cr>', 'coc#pum#visible() ? coc#pum#confirm() : "<CR>"', { expr = true, silent = true })
--vim.keymap.set('n', '<leader>a', '<Plug>(coc-codeaction)')

--vim.keymap.set('n', '[c', '<Plug>(coc-diagnostic-prev-error)', { silent = true })
--vim.keymap.set('n', ']c', '<Plug>(coc-diagnostic-next-error)', { silent = true })
--vim.keymap.set('n', '<leader>rn', '<Plug>(coc-rename)')

vim.g.gradle_path = "/usr/bin/gradle"
vim.g.android_sdk_path = "/home/alan/Android/Sdk"

--  Remap keys for gotos
--vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
--vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
--vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
--vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })

-- highlight LineNr term=bold ctermfg=grey
-- highlight CocInlayHint guibg=Red guifg=Blue ctermbg=Red ctermfg=Blue

--  VSCode like line moving
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv", { noremap = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv", { noremap = true })
vim.keymap.set('n', '<A-k>', ":m -2<CR>", { noremap = true })
vim.keymap.set('n', '<A-j>', ":m +1<CR>", { noremap = true })


-- vnoremap {{ "sc{<C-r>s}<Esc>
-- vnoremap [[ "sc[<C-r>s]<Esc>
-- vnoremap (( "sc(<C-r>s)<Esc>
-- vnoremap "" "sc"<C-r>s"<Esc>
-- vnoremap '' "sc'<C-r>s'<Esc>

-- nmap <C-e> :GFiles<CR>
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function()
	local opts = {} -- define here if you want to define something
	vim.fn.system('git rev-parse --is-inside-work-tree')
	if vim.v.shell_error == 0 then
		require "telescope.builtin".git_files(opts)
	else
		require "telescope.builtin".find_files(opts)
	end
end, {})
vim.keymap.set('n', '<leader>rg', builtin.live_grep, {})

local dap = require('dap')
dap.adapters.lldb = {
	type = 'executable',
	command = '/usr/bin/lldb-vscode',
	name = "lldb"
}
dap.adapters.c = {
	type = 'executable',
	command = '/usr/bin/lldb-vscode',
	name = "c"
}
dap.configurations.rust = {
	{
		name = "Launch Debug",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
}
dap.configurations.c = {
	{
		name = "launch",
		type = "lldb",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		request = "launch",
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
}
vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '⭐️', texthl = '', linehl = '', numhl = '' })
require('dap.ext.vscode').load_launchjs()


function define_dap_remap(mode, key, func_name)
	vim.keymap.set('n', '<leader>' .. key, ":lua " .. func_name .. "<CR>", { noremap = true })
end

define_dap_remap('n', 'dh', "require'dap'.toggle_breakpoint()")
define_dap_remap('n', 'k', "require'dap'.step_out()")
define_dap_remap('n', 'l', "require'dap'.step_into()")
define_dap_remap('n', 'j', "require'dap'.step_over()")
define_dap_remap('n', 'ds', "require'dap'.close()")
define_dap_remap('n', 'dn', "require'dap'.continue()")
define_dap_remap('n', 'dk', "require'dap'.up()")
define_dap_remap('n', 'dj', "require'dap'.down()")
define_dap_remap('n', 'd_', "require'dap'.disconnect();require'dap'.close();require'dap'.run_last()")
define_dap_remap('n', 'dr', "require'dap'.repl.open({}, 'vsplit')")
define_dap_remap('n', 'di', "require'dap.ui.widgets'.hover()")
define_dap_remap('v', 'di', "require'dap.ui.variables'.visual_hover()")
define_dap_remap('v', 'd?', "require'dap.ui.variables'.scopes()")
-- nnoremap <leader>de :lua require'dap'.set_exception_breakpoints({"all"})<CR>
-- nnoremap <leader>da :lua require'debugHelper'.attach()<CR>
-- nnoremap <leader>dA :lua require'debugHelper'.attachToRemote()<CR>
-- nnoremap <leader>di :lua require'dap.ui.widgets'.hover()<CR>
-- nnoremap <leader>d? :lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>

vim.g.fzf_action = {
	['ctrl-t'] = 'tab split',
	['ctrl-x'] = 'split',
	['ctrl-v'] = 'vsplit',
	['ctrl-q'] = 'fill_quickfix'
}

--vim.api.nvim_create_user_command('Prettier', 'Prettier :CocCommand prettier.formatFile', {})

vim.keymap.set('n', '<C-J>', '<C-W><C-J>')
vim.keymap.set('n', '<C-K>', '<C-W><C-K>')
vim.keymap.set('n', '<C-L>', '<C-W><C-L>')
vim.keymap.set('n', '<C-H>', '<C-W><C-H>')

vim.keymap.set('n', '<C-w>l', '<C-w>v<C-l>')
vim.keymap.set('n', '<C-w>h', '<C-w>v')
vim.keymap.set('n', '<C-w>j', '<C-w>s<C-j>')
vim.keymap.set('n', '<C-w>k', '<C-w>s')

vim.keymap.set('x', 'p', 'pgvy', { noremap = true })

vim.keymap.set('n', '<A-h>', ':tabp<CR>', { noremap = true })
vim.keymap.set('n', '<A-l>', ':tabn<CR>', { noremap = true })
vim.keymap.set('n', '<C-t>', ':tab split<CR>', { noremap = true })

-- tnoremap <Esc> <C-\><C-n>
-- tnoremap <C-c> <C-\><C-n>

vim.g.omni_sql_no_default_maps = 1

vim.keymap.set('n', '<Leader>c',
	[[:clear<bar>silent exec "!cp '%:p' '%:p:h/%:t:r-copy.%:e'"<bar>redraw<bar>echo "Copied " . expand('%:t') . ' to ' . expand('%:t:r') . '-copy.' . expand('%:e')<cr>]],
	{ noremap = true, silent = true })

require('swagger-preview').setup {
	-- The port to run the preview server on
	port = 8000,
	-- The host to run the preview server on
	host = "localhost",
}

require('lualine').setup {
	options = {
		path = 1
	},
	sections = {
		lualine_a = { 'lsp_progress', 'bo:filetype' }
	}
}

-- vim.opt.statusline^=%{coc#status()}

--vim.api.nvim_create_autocmd('User', { pattern = 'CocStatusChange', callback = 'redrawstatus' })
