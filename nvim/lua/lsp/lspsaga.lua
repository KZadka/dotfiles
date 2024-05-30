return {
    "nvimdev/lspsaga.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("lspsaga").setup({
            ui = {
                title = true,
                border = "rounded",
            },
            symbol_in_winbar = {
                enable = true,
            },
            outline = {
                layout = "float",
            },
            lightbulb = {
                enable = true,
                enable_in_insert = false,
                sign = true,
                sign_priority = 40,
                virtual_text = false,
            },
            definition = {
                width = 1.0,
                height = 1.0,
            },
        })
    end,
}
