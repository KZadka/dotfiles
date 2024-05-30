local ensure_installed_list = {
    -- INFO: black works fine but prefers " over '
    -- "black",
    "autopep8",
    "djlint",

    "prettierd",
    "eslint",
    "stylua",
    "shfmt",
}
return {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
        require("mason-null-ls").setup({
            ensure_installed = ensure_installed_list,
        })
    end,
}
