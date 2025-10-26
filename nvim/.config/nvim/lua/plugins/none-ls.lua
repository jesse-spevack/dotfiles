return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")

		-- Build sources list
		-- Note: Ruby linting/formatting is handled by ruby-lsp via .ruby-lsp.yml
		local sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.prettier,
			null_ls.builtins.diagnostics.eslint_d,
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.isort,
		}

		null_ls.setup({
			sources = sources,
		})

		vim.keymap.set("n", "<leader>gf", function()
			vim.lsp.buf.format({ async = false })
		end, { desc = "Format file" })
	end,
}
