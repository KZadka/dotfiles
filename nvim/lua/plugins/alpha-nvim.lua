-- dashboard plugin
local config_dir = "~/.config/nvim"
local function get_branch_name()
    local handle = io.popen('cd ' .. config_dir .. '; git rev-parse --abbrev-ref HEAD')
    local current_branch = string.gsub(handle:read("*a"), '%s+', '')
    handle:close()
    return current_branch
end

local function config_update_label()
    handle = io.popen('cd ' .. config_dir .. '; git rev-list --count upstream/' .. get_branch_name() .. ' ^HEAD')
    local output = handle:read("*a")
    handle:close()
    local update_count = tonumber(output) or 0
    return " Update config (" .. update_count .. " updates available)"
end

-- INFO: MVP
-- TODO: script for updating config?
local config_update_cmd = ":te cd " .. config_dir .. "; git pull upstream; echo 'Please restart NeoVim if necessary :)'<CR>"
-- local config_clean_cmd = ":!rm -rf ~/.local/share/nvim/; rm -rf ~/.local/state/nvim/; rm -rf ~/.cache/nvim/"

return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
            local dashboard = require("alpha.themes.dashboard")
            local logo = require("logo")
            dashboard.section.header.val = vim.split(logo, "\n")
            dashboard.section.buttons.val = {
                    dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
                    dashboard.button("s", " " .. " Find text", ":Telescope live_grep <CR>"),
                    dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
                    dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
                    -- dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
                    dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
                    -- dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
                    -- dashboard.button("u", "󰇚 " .. " Update plugins", ":Lazy update<CR>"),
                    -- TODO: change key
                    dashboard.button("c", " " .. config_update_label(), config_update_cmd),
                    -- TODO: dashboard.button("C", " " .. " Reinstall NeoVim plugins", config_clean_cmd),
                    dashboard.button("?", "󰋖 " .. " Show help", ":e ~/.config/nvim/SHORTCUTS.md<CR>"),
                    dashboard.button("q", " " .. " Quit", ":qa<CR>"),
            }
            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end
            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl = "AlphaFooter"
            dashboard.opts.layout[1].val = 8
            return dashboard
    end,
    config = function(_, dashboard)
        -- close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                        require("lazy").show()
                end,
            })
        end

        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}
