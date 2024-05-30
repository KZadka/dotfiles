return {
    "bennypowers/nvim-regexplainer",
    config = function()
        require("regexplainer").setup({
            auto = false,
            filetypes = {
                "html",
                "js",
                "cjs",
                "mjs",
                "ts",
                "jsx",
                "tsx",
                "cjsx",
                "mjsx",
                "py",
                "vue",
            },
        })
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "MunifTanjim/nui.nvim",
    },
}
