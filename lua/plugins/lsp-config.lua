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
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
			mason_lspconfig.setup({
				ensure_installed = {
					"gopls",
					"lua_ls",
					"elixirls",
					"pyright",
					"tsserver",
					"tsserver",
					"tailwindcss",
					"html",
					"cssls",
					"emmet_ls",
					"gradle_ls",
				},
			})
			mason_lspconfig.setup_handlers({
				function(server_name)
					if server_name ~= "jdtls" and server_name ~= "elixirls" then
						require("lspconfig")[server_name].setup({
							capabilities = lsp_capabilities,
						})
					end
					if server_name == "elixirls" then
						require("lspconfig")["elixir-ls"].setup({
							capabilities = lsp_capabilities,
						})
					end
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {})
			vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, {})
			vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, {})
			vim.keymap.set("n", "<space>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, {})
			vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, {})
			vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
			vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "gr", function()
				require("telescope.builtin").lsp_references()
			end, {})
			vim.keymap.set("n", "<space>f", function()
				vim.lsp.buf.format({ async = true })
			end, {})
		end,
	},
}
