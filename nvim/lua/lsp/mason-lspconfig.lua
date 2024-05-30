local server_list = {
    -- vue
    -- "vuels", -- Vue2
    "volar", -- Vue3 (Vue2 also works)

    -- javascript, typescript
    "eslint",
    "tsserver",

    -- Python
    "pyright",
    "ruff_lsp",

    "ansiblels",
    "bashls",
    "docker_compose_language_service",
    "dockerls",
    "lua_ls",
    "yamlls",
}
return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    config = function()
        local mason_lspconfig = require("mason-lspconfig")
        local lspconfig = require("lspconfig")
        mason_lspconfig.setup({
            -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
            -- This setting has no relation with the `automatic_installation` setting.
            ---@type string[]
            ensure_installed = server_list,

            -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
            -- This setting has no relation with the `ensure_installed` setting.
            -- Can either be:
            --   - false: Servers are not automatically installed.
            --   - true: All servers set up via lspconfig are automatically installed.
            --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
            --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
            ---@type boolean
            automatic_installation = true,

            -- See `:h mason-lspconfig.setup_handlers()`
            ---@type table<string, fun(server_name: string)>?
            handlers = nil,
        })

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        mason_lspconfig.setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end,
        })
        lspconfig.ruff_lsp.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            init_options = {
                settings = {
                    -- Any extra CLI arguments for `ruff` go here.
                    args = { "--line-length=80" },
                },
            },
        })
        lspconfig.pyright.setup(({
            capabilities = capabilities,
            on_attach = on_attach,
            handlers = {
                ["textDocument/publishDiagnostics"] = function() end,
            },
        }))
    end,
}
