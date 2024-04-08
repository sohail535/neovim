return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black", "ruff" },
				-- Use a sub-list to run only the first available formatter
				javascript = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
				htmldjango = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				elixir = { "mix" },
				java = { "google-java-format" },
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
