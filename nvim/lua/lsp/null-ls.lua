return {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- ensure installed by mason-null-ls
                null_ls.builtins.diagnostics.eslint.with({
                    only_local = "node_modules/.bin"
                }),
                -- null_ls.builtins.completion.spell,
                null_ls.builtins.formatting.autopep8,
                -- null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.djlint,
                null_ls.builtins.formatting.prettierd,
                null_ls.builtins.formatting.shfmt,
                null_ls.builtins.formatting.stylua,
            },
        })
    end,
}
