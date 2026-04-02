local on_attach = function(client, bufnr)
	local buf_opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, buf_opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, buf_opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, buf_opts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, buf_opts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, buf_opts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, buf_opts)

	vim.keymap.set('n', '<leader>fm', function()
		vim.lsp.buf.format({ async = true })
	end, buf_opts)
end

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- ========= NEW nvim 0.11 LSP API ========= --
			vim.lsp.config("html", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
					},
				},
			})

			vim.lsp.config("pyright", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					python = {
						formatting = { provider = "none" },
					},
				},
			})

			-- enable servers (MUST)
			vim.lsp.enable("html")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("pyright")
			-- =========================================== --

			-- Format Python on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.py",
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})

			-- Diagnostics config
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
			})

			-- Extra keybinds (global)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "ca", vim.lsp.buf.code_action, {})
		end,
	},

	-- Go config (kept same)
	{
		"ray-x/go.nvim",
		ft = { "go", "gomod" },
		event = { "CmdlineEnter" },
		build = ":lua require('go.install').update_all_sync()",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			lsp_inlay_hints = { enable = false },
			lsp_cfg = true,
			lsp_on_attach = on_attach,
		},
		config = function(_, opts)
			require("go").setup(opts)
			local grp = vim.api.nvim_create_augroup("GoFormat", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				group = grp,
				callback = function()
					require("go.format").goimports()
				end,
			})
		end,
	},
}
